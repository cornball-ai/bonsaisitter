#include <R.h>
#include <Rinternals.h>
#include <string.h>
#include <tree_sitter/api.h>

static TSNode raw_to_node(SEXP raw) {
    TSNode node;
    memcpy(&node, RAW(raw), sizeof(TSNode));
    return node;
}

/* -- Node error / state predicates -- */

SEXP c_ts_node_has_error(SEXP node_raw) {
    return Rf_ScalarLogical(ts_node_has_error(raw_to_node(node_raw)));
}

SEXP c_ts_node_is_error(SEXP node_raw) {
    return Rf_ScalarLogical(ts_node_is_error(raw_to_node(node_raw)));
}

SEXP c_ts_node_is_missing(SEXP node_raw) {
    return Rf_ScalarLogical(ts_node_is_missing(raw_to_node(node_raw)));
}

SEXP c_ts_node_is_extra(SEXP node_raw) {
    return Rf_ScalarLogical(ts_node_is_extra(raw_to_node(node_raw)));
}

SEXP c_ts_node_descendant_count(SEXP node_raw) {
    return Rf_ScalarInteger((int)ts_node_descendant_count(raw_to_node(node_raw)));
}

SEXP c_ts_node_grammar_type(SEXP node_raw) {
    const char *type = ts_node_grammar_type(raw_to_node(node_raw));
    return Rf_ScalarString(Rf_mkCharCE(type, CE_UTF8));
}

/* -- Language introspection -- */

SEXP c_ts_language_symbol_count(SEXP language_ptr) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    return Rf_ScalarInteger((int)ts_language_symbol_count(lang));
}

SEXP c_ts_language_symbol_name(SEXP language_ptr, SEXP id) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    const char *name = ts_language_symbol_name(lang, (TSSymbol)Rf_asInteger(id));
    if (!name) return Rf_ScalarString(NA_STRING);
    return Rf_ScalarString(Rf_mkCharCE(name, CE_UTF8));
}

SEXP c_ts_language_symbol_for_name(SEXP language_ptr, SEXP name, SEXP is_named) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    const char *nm = CHAR(STRING_ELT(name, 0));
    TSSymbol sym = ts_language_symbol_for_name(
        lang, nm, (uint32_t)strlen(nm), (bool)Rf_asLogical(is_named));
    return Rf_ScalarInteger((int)sym);
}

SEXP c_ts_language_field_count(SEXP language_ptr) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    return Rf_ScalarInteger((int)ts_language_field_count(lang));
}

SEXP c_ts_language_field_name_for_id(SEXP language_ptr, SEXP id) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    const char *name = ts_language_field_name_for_id(lang, (TSFieldId)Rf_asInteger(id));
    if (!name) return Rf_ScalarString(NA_STRING);
    return Rf_ScalarString(Rf_mkCharCE(name, CE_UTF8));
}

SEXP c_ts_language_field_id_for_name(SEXP language_ptr, SEXP name) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    const char *nm = CHAR(STRING_ELT(name, 0));
    TSFieldId id = ts_language_field_id_for_name(lang, nm, (uint32_t)strlen(nm));
    return Rf_ScalarInteger((int)id);
}
