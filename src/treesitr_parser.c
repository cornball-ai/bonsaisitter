#include <R.h>
#include <Rinternals.h>
#include <time.h>
#include <tree_sitter/api.h>

static void parser_finalizer(SEXP ptr) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(ptr);
    if (parser) {
        ts_parser_delete(parser);
        R_ClearExternalPtr(ptr);
    }
}

SEXP c_ts_parser_new(void) {
    TSParser *parser = ts_parser_new();
    if (!parser) {
        Rf_error("failed to create parser");
    }
    SEXP ptr = PROTECT(R_MakeExternalPtr(parser, R_NilValue, R_NilValue));
    R_RegisterCFinalizer(ptr, parser_finalizer);
    UNPROTECT(1);
    return ptr;
}

/* `language_ptr` is the external pointer inside a tree_sitter_language object
   (its `$pointer`), so bonsaisitter accepts posit grammar packages directly.
   Returns TRUE on success, FALSE on ABI mismatch. */
SEXP c_ts_parser_set_language(SEXP parser_ptr, SEXP language_ptr) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(parser_ptr);
    if (!parser) Rf_error("parser has been freed");
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    if (!lang) Rf_error("language has been freed");
    bool ok = ts_parser_set_language(parser, lang);
    return Rf_ScalarLogical(ok);
}

/* This runtime dropped ts_parser_set_timeout_micros; timeouts run through the
   progress callback of ts_parser_parse_with_options with a monotonic deadline.
   R is single-threaded, so a file-static deadline is safe. */
static double now_us(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec * 1e6 + (double)ts.tv_nsec / 1e3;
}

static double g_deadline_us = 0.0;

static bool deadline_callback(TSParseState *state) {
    (void)state;
    return g_deadline_us > 0.0 && now_us() > g_deadline_us;
}

typedef struct {
    const char *text;
    uint32_t len;
} string_input_t;

static const char *string_read(void *payload, uint32_t byte, TSPoint pos, uint32_t *bytes_read) {
    (void)pos;
    string_input_t *si = (string_input_t *)payload;
    if (byte >= si->len) {
        *bytes_read = 0;
        return "";
    }
    *bytes_read = si->len - byte;
    return si->text + byte;
}

/* timeout_us <= 0 means no limit (plain string parse). */
static TSTree *do_parse(TSParser *parser, const TSTree *old,
                        const char *src, uint32_t len, double timeout_us) {
    if (timeout_us <= 0.0) {
        return ts_parser_parse_string(parser, old, src, len);
    }
    string_input_t si = {src, len};
    TSInput input = {&si, string_read, TSInputEncodingUTF8, NULL};
    g_deadline_us = now_us() + timeout_us;
    TSParseOptions opts = {NULL, deadline_callback};
    TSTree *tree = ts_parser_parse_with_options(parser, old, input, opts);
    g_deadline_us = 0.0;
    return tree;
}

/* Returns the parsed tree's bare external pointer. The R layer registers the
   finalizer and wraps it into list(pointer, text, language). */
SEXP c_ts_parse(SEXP parser_ptr, SEXP source_str, SEXP old_tree_ptr, SEXP timeout) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(parser_ptr);
    if (!parser) Rf_error("parser has been freed");

    const char *src = CHAR(STRING_ELT(source_str, 0));
    uint32_t len = (uint32_t)LENGTH(STRING_ELT(source_str, 0));
    double timeout_us = Rf_asReal(timeout);

    const TSTree *old_tree = NULL;
    if (!Rf_isNull(old_tree_ptr)) {
        old_tree = (const TSTree *)R_ExternalPtrAddr(old_tree_ptr);
    }

    TSTree *tree = do_parse(parser, old_tree, src, len, timeout_us);
    if (!tree) {
        if (timeout_us > 0.0) Rf_error("parse timed out");
        Rf_error("parsing failed (no language set?)");
    }

    return R_MakeExternalPtr(tree, R_NilValue, R_NilValue);
}

SEXP c_ts_parser_set_included_ranges(SEXP parser_ptr, SEXP sb, SEXP sr, SEXP sc,
                                     SEXP eb, SEXP er, SEXP ec) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(parser_ptr);
    if (!parser) Rf_error("parser has been freed");

    uint32_t n = (uint32_t)LENGTH(sb);
    TSRange *ranges = (TSRange *)R_alloc(n == 0 ? 1 : n, sizeof(TSRange));
    for (uint32_t i = 0; i < n; i++) {
        ranges[i].start_byte = (uint32_t)REAL(sb)[i];
        ranges[i].start_point.row = (uint32_t)REAL(sr)[i];
        ranges[i].start_point.column = (uint32_t)REAL(sc)[i];
        ranges[i].end_byte = (uint32_t)REAL(eb)[i];
        ranges[i].end_point.row = (uint32_t)REAL(er)[i];
        ranges[i].end_point.column = (uint32_t)REAL(ec)[i];
    }
    bool ok = ts_parser_set_included_ranges(parser, ranges, n);
    return Rf_ScalarLogical(ok);
}

/* Incremental reparse: copy the old tree so the caller's tree stays valid,
   apply the edit to the copy, reparse using it, then free the copy. */
SEXP c_ts_reparse(SEXP parser_ptr, SEXP source_str, SEXP old_tree_ptr, SEXP timeout,
                  SEXP start_byte, SEXP old_end_byte, SEXP new_end_byte,
                  SEXP start_row, SEXP start_col, SEXP old_end_row, SEXP old_end_col,
                  SEXP new_end_row, SEXP new_end_col) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(parser_ptr);
    if (!parser) Rf_error("parser has been freed");
    const TSTree *old_tree = (const TSTree *)R_ExternalPtrAddr(old_tree_ptr);
    if (!old_tree) Rf_error("tree has been freed");

    TSTree *copy = ts_tree_copy(old_tree);
    TSInputEdit edit;
    edit.start_byte = (uint32_t)Rf_asReal(start_byte);
    edit.old_end_byte = (uint32_t)Rf_asReal(old_end_byte);
    edit.new_end_byte = (uint32_t)Rf_asReal(new_end_byte);
    edit.start_point.row = (uint32_t)Rf_asInteger(start_row);
    edit.start_point.column = (uint32_t)Rf_asInteger(start_col);
    edit.old_end_point.row = (uint32_t)Rf_asInteger(old_end_row);
    edit.old_end_point.column = (uint32_t)Rf_asInteger(old_end_col);
    edit.new_end_point.row = (uint32_t)Rf_asInteger(new_end_row);
    edit.new_end_point.column = (uint32_t)Rf_asInteger(new_end_col);
    ts_tree_edit(copy, &edit);

    const char *src = CHAR(STRING_ELT(source_str, 0));
    uint32_t len = (uint32_t)LENGTH(STRING_ELT(source_str, 0));
    double timeout_us = Rf_asReal(timeout);

    TSTree *tree = do_parse(parser, copy, src, len, timeout_us);
    ts_tree_delete(copy);
    if (!tree) {
        if (timeout_us > 0.0) Rf_error("parse timed out");
        Rf_error("reparse failed");
    }

    return R_MakeExternalPtr(tree, R_NilValue, R_NilValue);
}
