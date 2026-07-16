#include <R.h>
#include <Rinternals.h>
#include <string.h>
#include <tree_sitter/api.h>

static TSNode raw_to_node(SEXP raw) {
    TSNode node;
    memcpy(&node, RAW(raw), sizeof(TSNode));
    return node;
}

static SEXP node_as_raw(TSNode node) {
    SEXP raw = PROTECT(Rf_allocVector(RAWSXP, sizeof(TSNode)));
    memcpy(RAW(raw), &node, sizeof(TSNode));
    UNPROTECT(1);
    return raw;
}

static void query_finalizer(SEXP ptr) {
    TSQuery *q = (TSQuery *)R_ExternalPtrAddr(ptr);
    if (q) {
        ts_query_delete(q);
        R_ClearExternalPtr(ptr);
    }
}

SEXP c_ts_query_new(SEXP language_ptr, SEXP source_str) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    if (!lang) Rf_error("language has been freed");
    const char *src = CHAR(STRING_ELT(source_str, 0));
    uint32_t len = (uint32_t)LENGTH(STRING_ELT(source_str, 0));

    uint32_t err_offset = 0;
    TSQueryError err_type = TSQueryErrorNone;
    TSQuery *q = ts_query_new(lang, src, len, &err_offset, &err_type);
    if (!q) {
        Rf_error("failed to compile query (error type %d at byte %u)",
                 (int)err_type, err_offset);
    }

    SEXP ptr = PROTECT(R_MakeExternalPtr(q, R_NilValue, R_NilValue));
    R_RegisterCFinalizer(ptr, query_finalizer);
    UNPROTECT(1);
    return ptr;
}

SEXP c_ts_query_capture_names(SEXP query_ptr) {
    TSQuery *q = (TSQuery *)R_ExternalPtrAddr(query_ptr);
    uint32_t n = ts_query_capture_count(q);
    SEXP out = PROTECT(Rf_allocVector(STRSXP, n));
    for (uint32_t i = 0; i < n; i++) {
        uint32_t len = 0;
        const char *name = ts_query_capture_name_for_id(q, i, &len);
        SET_STRING_ELT(out, i, Rf_mkCharLenCE(name, (int)len, CE_UTF8));
    }
    UNPROTECT(1);
    return out;
}

SEXP c_ts_query_pattern_count(SEXP query_ptr) {
    return Rf_ScalarInteger((int)ts_query_pattern_count((TSQuery *)R_ExternalPtrAddr(query_ptr)));
}

SEXP c_ts_query_capture_count(SEXP query_ptr) {
    return Rf_ScalarInteger((int)ts_query_capture_count((TSQuery *)R_ExternalPtrAddr(query_ptr)));
}

SEXP c_ts_query_string_count(SEXP query_ptr) {
    return Rf_ScalarInteger((int)ts_query_string_count((TSQuery *)R_ExternalPtrAddr(query_ptr)));
}

/* Returns list(name = character, node = list of bare raws), all captures in
   traversal order. Two passes over a fresh cursor exec so we can size the R
   vectors exactly without a growable C buffer. */
SEXP c_ts_query_captures(SEXP query_ptr, SEXP node_raw) {
    TSQuery *q = (TSQuery *)R_ExternalPtrAddr(query_ptr);
    TSNode node = raw_to_node(node_raw);

    TSQueryCursor *cursor = ts_query_cursor_new();
    TSQueryMatch match;
    uint32_t capture_index;

    ts_query_cursor_exec(cursor, q, node);
    uint32_t count = 0;
    while (ts_query_cursor_next_capture(cursor, &match, &capture_index)) {
        count++;
    }

    SEXP names = PROTECT(Rf_allocVector(STRSXP, count));
    SEXP node_list = PROTECT(Rf_allocVector(VECSXP, count));

    ts_query_cursor_exec(cursor, q, node);
    uint32_t i = 0;
    while (ts_query_cursor_next_capture(cursor, &match, &capture_index) && i < count) {
        TSQueryCapture c = match.captures[capture_index];
        uint32_t len = 0;
        const char *name = ts_query_capture_name_for_id(q, c.index, &len);
        SET_STRING_ELT(names, i, Rf_mkCharLenCE(name, (int)len, CE_UTF8));
        SET_VECTOR_ELT(node_list, i, node_as_raw(c.node));
        i++;
    }
    ts_query_cursor_delete(cursor);

    SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
    SET_VECTOR_ELT(out, 0, names);
    SET_VECTOR_ELT(out, 1, node_list);
    SEXP nm = PROTECT(Rf_allocVector(STRSXP, 2));
    SET_STRING_ELT(nm, 0, Rf_mkChar("name"));
    SET_STRING_ELT(nm, 1, Rf_mkChar("node"));
    Rf_setAttrib(out, R_NamesSymbol, nm);

    UNPROTECT(4);
    return out;
}
