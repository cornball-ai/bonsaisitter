#include <R.h>
#include <Rinternals.h>
#include <string.h>
#include <tree_sitter/api.h>

/* Helper: reconstruct TSNode from raw vector */
static TSNode raw_to_node(SEXP raw) {
    TSNode node;
    memcpy(&node, RAW(raw), sizeof(TSNode));
    return node;
}

/* Helper: wrap TSNode as raw vector with tree attribute */
static SEXP node_to_raw(TSNode node, SEXP tree_obj) {
    if (ts_node_is_null(node)) return R_NilValue;
    SEXP raw = PROTECT(Rf_allocVector(RAWSXP, sizeof(TSNode)));
    memcpy(RAW(raw), &node, sizeof(TSNode));
    Rf_setAttrib(raw, Rf_install("tree"), tree_obj);
    Rf_setAttrib(raw, R_ClassSymbol, Rf_mkString("ts_node"));
    UNPROTECT(1);
    return raw;
}

SEXP c_ts_node_type(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    const char *type = ts_node_type(node);
    return Rf_ScalarString(Rf_mkCharCE(type, CE_UTF8));
}

SEXP c_ts_node_is_named(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    return Rf_ScalarLogical(ts_node_is_named(node));
}

SEXP c_ts_node_is_null(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    return Rf_ScalarLogical(ts_node_is_null(node));
}

SEXP c_ts_node_start_point(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    TSPoint pt = ts_node_start_point(node);
    SEXP result = PROTECT(Rf_allocVector(INTSXP, 2));
    INTEGER(result)[0] = (int)pt.row;
    INTEGER(result)[1] = (int)pt.column;
    SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
    SET_STRING_ELT(names, 0, Rf_mkChar("row"));
    SET_STRING_ELT(names, 1, Rf_mkChar("column"));
    Rf_setAttrib(result, R_NamesSymbol, names);
    UNPROTECT(2);
    return result;
}

SEXP c_ts_node_end_point(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    TSPoint pt = ts_node_end_point(node);
    SEXP result = PROTECT(Rf_allocVector(INTSXP, 2));
    INTEGER(result)[0] = (int)pt.row;
    INTEGER(result)[1] = (int)pt.column;
    SEXP names = PROTECT(Rf_allocVector(STRSXP, 2));
    SET_STRING_ELT(names, 0, Rf_mkChar("row"));
    SET_STRING_ELT(names, 1, Rf_mkChar("column"));
    Rf_setAttrib(result, R_NamesSymbol, names);
    UNPROTECT(2);
    return result;
}

SEXP c_ts_node_start_byte(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    return Rf_ScalarInteger((int)ts_node_start_byte(node));
}

SEXP c_ts_node_end_byte(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    return Rf_ScalarInteger((int)ts_node_end_byte(node));
}

SEXP c_ts_node_child_count(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    return Rf_ScalarInteger((int)ts_node_child_count(node));
}

SEXP c_ts_node_named_child_count(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    return Rf_ScalarInteger((int)ts_node_named_child_count(node));
}

SEXP c_ts_node_child(SEXP node_raw, SEXP index) {
    TSNode node = raw_to_node(node_raw);
    uint32_t i = (uint32_t)Rf_asInteger(index);
    TSNode child = ts_node_child(node, i);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(child, tree_obj);
}

SEXP c_ts_node_named_child(SEXP node_raw, SEXP index) {
    TSNode node = raw_to_node(node_raw);
    uint32_t i = (uint32_t)Rf_asInteger(index);
    TSNode child = ts_node_named_child(node, i);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(child, tree_obj);
}

SEXP c_ts_node_parent(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    TSNode parent = ts_node_parent(node);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(parent, tree_obj);
}

SEXP c_ts_node_next_sibling(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    TSNode sib = ts_node_next_sibling(node);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(sib, tree_obj);
}

SEXP c_ts_node_prev_sibling(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    TSNode sib = ts_node_prev_sibling(node);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(sib, tree_obj);
}

SEXP c_ts_node_next_named_sibling(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    TSNode sib = ts_node_next_named_sibling(node);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(sib, tree_obj);
}

SEXP c_ts_node_prev_named_sibling(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    TSNode sib = ts_node_prev_named_sibling(node);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(sib, tree_obj);
}

SEXP c_ts_node_child_by_field(SEXP node_raw, SEXP name) {
    TSNode node = raw_to_node(node_raw);
    const char *field = CHAR(STRING_ELT(name, 0));
    TSNode child = ts_node_child_by_field_name(node, field, (uint32_t)strlen(field));
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    return node_to_raw(child, tree_obj);
}

SEXP c_ts_node_text(SEXP node_raw, SEXP source_str) {
    TSNode node = raw_to_node(node_raw);
    const char *src = CHAR(STRING_ELT(source_str, 0));
    uint32_t start = ts_node_start_byte(node);
    uint32_t end = ts_node_end_byte(node);
    if (end < start) return Rf_ScalarString(Rf_mkCharLen("", 0));
    uint32_t len = end - start;
    return Rf_ScalarString(Rf_mkCharLenCE(src + start, (int)len, CE_UTF8));
}

SEXP c_ts_node_sexpr(SEXP node_raw) {
    TSNode node = raw_to_node(node_raw);
    char *str = ts_node_string(node);
    SEXP result = PROTECT(Rf_ScalarString(Rf_mkCharCE(str, CE_UTF8)));
    free(str);
    UNPROTECT(1);
    return result;
}

SEXP c_ts_node_children(SEXP node_raw, SEXP named) {
    TSNode node = raw_to_node(node_raw);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    int use_named = Rf_asLogical(named);

    uint32_t count = use_named ?
        ts_node_named_child_count(node) :
        ts_node_child_count(node);

    SEXP result = PROTECT(Rf_allocVector(VECSXP, count));
    for (uint32_t i = 0; i < count; i++) {
        TSNode child = use_named ?
            ts_node_named_child(node, i) :
            ts_node_child(node, i);
        SET_VECTOR_ELT(result, i, node_to_raw(child, tree_obj));
    }
    UNPROTECT(1);
    return result;
}

/* Recursive helper for as.data.frame */
static void collect_descendants(TSNode node, SEXP tree_obj, const char *src,
                                 int *idx, int max_n,
                                 SEXP types, SEXP named_vec, SEXP texts,
                                 SEXP start_rows, SEXP start_cols,
                                 SEXP end_rows, SEXP end_cols,
                                 SEXP start_bytes, SEXP end_bytes) {
    if (*idx >= max_n) return;
    int i = *idx;
    (*idx)++;

    SET_STRING_ELT(types, i, Rf_mkCharCE(ts_node_type(node), CE_UTF8));
    LOGICAL(named_vec)[i] = ts_node_is_named(node);

    uint32_t sb = ts_node_start_byte(node);
    uint32_t eb = ts_node_end_byte(node);
    if (eb >= sb) {
        SET_STRING_ELT(texts, i, Rf_mkCharLenCE(src + sb, (int)(eb - sb), CE_UTF8));
    } else {
        SET_STRING_ELT(texts, i, Rf_mkChar(""));
    }

    TSPoint sp = ts_node_start_point(node);
    TSPoint ep = ts_node_end_point(node);
    INTEGER(start_rows)[i] = (int)sp.row;
    INTEGER(start_cols)[i] = (int)sp.column;
    INTEGER(end_rows)[i] = (int)ep.row;
    INTEGER(end_cols)[i] = (int)ep.column;
    INTEGER(start_bytes)[i] = (int)sb;
    INTEGER(end_bytes)[i] = (int)eb;

    uint32_t n = ts_node_child_count(node);
    for (uint32_t c = 0; c < n; c++) {
        collect_descendants(ts_node_child(node, c), tree_obj, src,
                           idx, max_n, types, named_vec, texts,
                           start_rows, start_cols, end_rows, end_cols,
                           start_bytes, end_bytes);
    }
}

SEXP c_ts_node_descendants_df(SEXP node_raw, SEXP source_str) {
    TSNode node = raw_to_node(node_raw);
    SEXP tree_obj = Rf_getAttrib(node_raw, Rf_install("tree"));
    const char *src = CHAR(STRING_ELT(source_str, 0));

    int n = (int)ts_node_descendant_count(node);

    SEXP types = PROTECT(Rf_allocVector(STRSXP, n));
    SEXP named_vec = PROTECT(Rf_allocVector(LGLSXP, n));
    SEXP texts = PROTECT(Rf_allocVector(STRSXP, n));
    SEXP start_rows = PROTECT(Rf_allocVector(INTSXP, n));
    SEXP start_cols = PROTECT(Rf_allocVector(INTSXP, n));
    SEXP end_rows = PROTECT(Rf_allocVector(INTSXP, n));
    SEXP end_cols = PROTECT(Rf_allocVector(INTSXP, n));
    SEXP start_bytes = PROTECT(Rf_allocVector(INTSXP, n));
    SEXP end_bytes = PROTECT(Rf_allocVector(INTSXP, n));

    int idx = 0;
    collect_descendants(node, tree_obj, src, &idx, n,
                       types, named_vec, texts,
                       start_rows, start_cols, end_rows, end_cols,
                       start_bytes, end_bytes);

    /* Build data.frame */
    SEXP df = PROTECT(Rf_allocVector(VECSXP, 9));
    SET_VECTOR_ELT(df, 0, types);
    SET_VECTOR_ELT(df, 1, named_vec);
    SET_VECTOR_ELT(df, 2, texts);
    SET_VECTOR_ELT(df, 3, start_rows);
    SET_VECTOR_ELT(df, 4, start_cols);
    SET_VECTOR_ELT(df, 5, end_rows);
    SET_VECTOR_ELT(df, 6, end_cols);
    SET_VECTOR_ELT(df, 7, start_bytes);
    SET_VECTOR_ELT(df, 8, end_bytes);

    SEXP col_names = PROTECT(Rf_allocVector(STRSXP, 9));
    SET_STRING_ELT(col_names, 0, Rf_mkChar("type"));
    SET_STRING_ELT(col_names, 1, Rf_mkChar("named"));
    SET_STRING_ELT(col_names, 2, Rf_mkChar("text"));
    SET_STRING_ELT(col_names, 3, Rf_mkChar("start_row"));
    SET_STRING_ELT(col_names, 4, Rf_mkChar("start_col"));
    SET_STRING_ELT(col_names, 5, Rf_mkChar("end_row"));
    SET_STRING_ELT(col_names, 6, Rf_mkChar("end_col"));
    SET_STRING_ELT(col_names, 7, Rf_mkChar("start_byte"));
    SET_STRING_ELT(col_names, 8, Rf_mkChar("end_byte"));
    Rf_setAttrib(df, R_NamesSymbol, col_names);

    SEXP row_names = PROTECT(Rf_allocVector(INTSXP, 2));
    INTEGER(row_names)[0] = NA_INTEGER;
    INTEGER(row_names)[1] = -n;
    Rf_setAttrib(df, R_RowNamesSymbol, row_names);
    Rf_setAttrib(df, R_ClassSymbol, Rf_mkString("data.frame"));

    UNPROTECT(12);
    return df;
}
