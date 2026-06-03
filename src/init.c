#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <tree_sitter/api.h>

/* tree-sitter grammar entry points */
extern const TSLanguage *tree_sitter_r(void);
extern const TSLanguage *tree_sitter_python(void);
extern const TSLanguage *tree_sitter_cpp(void);

/* Language */
SEXP c_ts_language_r(void) {
    const TSLanguage *lang = tree_sitter_r();
    SEXP ptr = PROTECT(R_MakeExternalPtr((void *)lang, R_NilValue, R_NilValue));
    /* No finalizer — static data, not heap-allocated */
    Rf_setAttrib(ptr, R_ClassSymbol, Rf_mkString("ts_language"));
    UNPROTECT(1);
    return ptr;
}

SEXP c_ts_language_python(void) {
    const TSLanguage *lang = tree_sitter_python();
    SEXP ptr = PROTECT(R_MakeExternalPtr((void *)lang, R_NilValue, R_NilValue));
    Rf_setAttrib(ptr, R_ClassSymbol, Rf_mkString("ts_language"));
    UNPROTECT(1);
    return ptr;
}

SEXP c_ts_language_cpp(void) {
    const TSLanguage *lang = tree_sitter_cpp();
    SEXP ptr = PROTECT(R_MakeExternalPtr((void *)lang, R_NilValue, R_NilValue));
    Rf_setAttrib(ptr, R_ClassSymbol, Rf_mkString("ts_language"));
    UNPROTECT(1);
    return ptr;
}

/* Parser */
extern SEXP c_ts_parser_new(void);
extern SEXP c_ts_parser_set_language(SEXP, SEXP);
extern SEXP c_ts_parse(SEXP, SEXP, SEXP);

/* Tree */
extern SEXP c_ts_tree_register_finalizer(SEXP);
extern SEXP c_ts_tree_root_node(SEXP);

/* Node */
extern SEXP c_ts_node_type(SEXP);
extern SEXP c_ts_node_is_named(SEXP);
extern SEXP c_ts_node_is_null(SEXP);
extern SEXP c_ts_node_start_point(SEXP);
extern SEXP c_ts_node_end_point(SEXP);
extern SEXP c_ts_node_start_byte(SEXP);
extern SEXP c_ts_node_end_byte(SEXP);
extern SEXP c_ts_node_child_count(SEXP);
extern SEXP c_ts_node_named_child_count(SEXP);
extern SEXP c_ts_node_child(SEXP, SEXP);
extern SEXP c_ts_node_named_child(SEXP, SEXP);
extern SEXP c_ts_node_parent(SEXP);
extern SEXP c_ts_node_next_sibling(SEXP);
extern SEXP c_ts_node_prev_sibling(SEXP);
extern SEXP c_ts_node_next_named_sibling(SEXP);
extern SEXP c_ts_node_prev_named_sibling(SEXP);
extern SEXP c_ts_node_child_by_field(SEXP, SEXP);
extern SEXP c_ts_node_text(SEXP, SEXP);
extern SEXP c_ts_node_sexpr(SEXP);
extern SEXP c_ts_node_children(SEXP, SEXP);
extern SEXP c_ts_node_descendants_df(SEXP, SEXP);

/* Cursor */
extern SEXP c_ts_cursor_new(SEXP, SEXP);
extern SEXP c_ts_cursor_node(SEXP);
extern SEXP c_ts_cursor_goto_first_child(SEXP);
extern SEXP c_ts_cursor_goto_next_sibling(SEXP);
extern SEXP c_ts_cursor_goto_parent(SEXP);
extern SEXP c_ts_cursor_field_name(SEXP);
extern SEXP c_ts_cursor_depth(SEXP);

static const R_CallMethodDef CallEntries[] = {
    /* Language */
    {"c_ts_language_r",              (DL_FUNC) &c_ts_language_r,              0},
    {"c_ts_language_python",         (DL_FUNC) &c_ts_language_python,         0},
    {"c_ts_language_cpp",            (DL_FUNC) &c_ts_language_cpp,            0},
    /* Parser */
    {"c_ts_parser_new",              (DL_FUNC) &c_ts_parser_new,              0},
    {"c_ts_parser_set_language",     (DL_FUNC) &c_ts_parser_set_language,     2},
    {"c_ts_parse",                   (DL_FUNC) &c_ts_parse,                   3},
    /* Tree */
    {"c_ts_tree_register_finalizer", (DL_FUNC) &c_ts_tree_register_finalizer, 1},
    {"c_ts_tree_root_node",          (DL_FUNC) &c_ts_tree_root_node,          1},
    /* Node */
    {"c_ts_node_type",               (DL_FUNC) &c_ts_node_type,               1},
    {"c_ts_node_is_named",           (DL_FUNC) &c_ts_node_is_named,           1},
    {"c_ts_node_is_null",            (DL_FUNC) &c_ts_node_is_null,            1},
    {"c_ts_node_start_point",        (DL_FUNC) &c_ts_node_start_point,        1},
    {"c_ts_node_end_point",          (DL_FUNC) &c_ts_node_end_point,          1},
    {"c_ts_node_start_byte",         (DL_FUNC) &c_ts_node_start_byte,         1},
    {"c_ts_node_end_byte",           (DL_FUNC) &c_ts_node_end_byte,           1},
    {"c_ts_node_child_count",        (DL_FUNC) &c_ts_node_child_count,        1},
    {"c_ts_node_named_child_count",  (DL_FUNC) &c_ts_node_named_child_count,  1},
    {"c_ts_node_child",              (DL_FUNC) &c_ts_node_child,              2},
    {"c_ts_node_named_child",        (DL_FUNC) &c_ts_node_named_child,        2},
    {"c_ts_node_parent",             (DL_FUNC) &c_ts_node_parent,             1},
    {"c_ts_node_next_sibling",       (DL_FUNC) &c_ts_node_next_sibling,       1},
    {"c_ts_node_prev_sibling",       (DL_FUNC) &c_ts_node_prev_sibling,       1},
    {"c_ts_node_next_named_sibling", (DL_FUNC) &c_ts_node_next_named_sibling, 1},
    {"c_ts_node_prev_named_sibling", (DL_FUNC) &c_ts_node_prev_named_sibling, 1},
    {"c_ts_node_child_by_field",     (DL_FUNC) &c_ts_node_child_by_field,     2},
    {"c_ts_node_text",               (DL_FUNC) &c_ts_node_text,               2},
    {"c_ts_node_sexpr",              (DL_FUNC) &c_ts_node_sexpr,              1},
    {"c_ts_node_children",           (DL_FUNC) &c_ts_node_children,           2},
    {"c_ts_node_descendants_df",     (DL_FUNC) &c_ts_node_descendants_df,     2},
    /* Cursor */
    {"c_ts_cursor_new",              (DL_FUNC) &c_ts_cursor_new,              2},
    {"c_ts_cursor_node",             (DL_FUNC) &c_ts_cursor_node,             1},
    {"c_ts_cursor_goto_first_child", (DL_FUNC) &c_ts_cursor_goto_first_child, 1},
    {"c_ts_cursor_goto_next_sibling",(DL_FUNC) &c_ts_cursor_goto_next_sibling,1},
    {"c_ts_cursor_goto_parent",      (DL_FUNC) &c_ts_cursor_goto_parent,      1},
    {"c_ts_cursor_field_name",       (DL_FUNC) &c_ts_cursor_field_name,       1},
    {"c_ts_cursor_depth",            (DL_FUNC) &c_ts_cursor_depth,            1},
    {NULL, NULL, 0}
};

void R_init_treesitR(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
