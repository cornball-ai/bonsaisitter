#include <R.h>
#include <Rinternals.h>
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

/* Returns the parsed tree's bare external pointer. The R layer registers the
   finalizer and wraps it into list(pointer, text, language). */
SEXP c_ts_parse(SEXP parser_ptr, SEXP source_str, SEXP old_tree_ptr) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(parser_ptr);
    if (!parser) Rf_error("parser has been freed");

    const char *src = CHAR(STRING_ELT(source_str, 0));
    uint32_t len = (uint32_t)LENGTH(STRING_ELT(source_str, 0));

    const TSTree *old_tree = NULL;
    if (!Rf_isNull(old_tree_ptr)) {
        old_tree = (const TSTree *)R_ExternalPtrAddr(old_tree_ptr);
    }

    TSTree *tree = ts_parser_parse_string(parser, old_tree, src, len);
    if (!tree) {
        Rf_error("parsing failed (no language set?)");
    }

    return R_MakeExternalPtr(tree, R_NilValue, R_NilValue);
}
