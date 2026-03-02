#include <R.h>
#include <Rinternals.h>
#include <tree_sitter/api.h>

/* Forward declaration for language */
extern const TSLanguage *tree_sitter_r(void);

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
    Rf_setAttrib(ptr, R_ClassSymbol, Rf_mkString("ts_parser"));
    UNPROTECT(1);
    return ptr;
}

SEXP c_ts_parser_set_language(SEXP parser_ptr, SEXP language_ptr) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(parser_ptr);
    if (!parser) Rf_error("parser has been freed");
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    if (!lang) Rf_error("language has been freed");
    bool ok = ts_parser_set_language(parser, lang);
    return Rf_ScalarLogical(ok);
}

SEXP c_ts_parse(SEXP parser_ptr, SEXP source_str, SEXP old_tree_obj) {
    TSParser *parser = (TSParser *)R_ExternalPtrAddr(parser_ptr);
    if (!parser) Rf_error("parser has been freed");

    const char *src = CHAR(STRING_ELT(source_str, 0));
    uint32_t len = (uint32_t)LENGTH(STRING_ELT(source_str, 0));

    const TSTree *old_tree = NULL;
    if (!Rf_isNull(old_tree_obj)) {
        SEXP old_ptr = VECTOR_ELT(old_tree_obj, 0);
        old_tree = (const TSTree *)R_ExternalPtrAddr(old_ptr);
    }

    TSTree *tree = ts_parser_parse_string(parser, old_tree, src, len);
    if (!tree) {
        Rf_error("parsing failed (no language set?)");
    }

    /* Return list(ptr = externalptr, source = character) */
    SEXP tree_ptr = PROTECT(R_MakeExternalPtr(tree, R_NilValue, R_NilValue));
    /* No finalizer here — the R list object holds the tree alive,
       and we register the finalizer on the list wrapper via R code.
       Actually, register here for safety. */
    SEXP result = PROTECT(Rf_allocVector(VECSXP, 2));
    SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
    SET_STRING_ELT(names, 0, Rf_mkChar("ptr"));
    SET_STRING_ELT(names, 1, Rf_mkChar("source"));
    Rf_setAttrib(result, R_NamesSymbol, names);
    SET_VECTOR_ELT(result, 0, tree_ptr);
    SET_VECTOR_ELT(result, 1, source_str);
    Rf_setAttrib(result, R_ClassSymbol, Rf_mkString("ts_tree"));
    UNPROTECT(3);
    return result;
}
