#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <tree_sitter/api.h>

/* Parser */
extern SEXP c_ts_parser_new(void);
extern SEXP c_ts_parser_set_language(SEXP, SEXP);
extern SEXP c_ts_parse(SEXP, SEXP, SEXP, SEXP);
extern SEXP c_ts_parser_set_included_ranges(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP c_ts_reparse(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);

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

/* Query */
extern SEXP c_ts_query_new(SEXP, SEXP);
extern SEXP c_ts_query_capture_names(SEXP);
extern SEXP c_ts_query_pattern_count(SEXP);
extern SEXP c_ts_query_capture_count(SEXP);
extern SEXP c_ts_query_string_count(SEXP);
extern SEXP c_ts_query_captures(SEXP, SEXP);

/* Introspection */
extern SEXP c_ts_node_has_error(SEXP);
extern SEXP c_ts_node_is_error(SEXP);
extern SEXP c_ts_node_is_missing(SEXP);
extern SEXP c_ts_node_is_extra(SEXP);
extern SEXP c_ts_node_descendant_count(SEXP);
extern SEXP c_ts_node_grammar_type(SEXP);
extern SEXP c_ts_language_symbol_count(SEXP);
extern SEXP c_ts_language_symbol_name(SEXP, SEXP);
extern SEXP c_ts_language_symbol_for_name(SEXP, SEXP, SEXP);
extern SEXP c_ts_language_field_count(SEXP);
extern SEXP c_ts_language_field_name_for_id(SEXP, SEXP);
extern SEXP c_ts_language_field_id_for_name(SEXP, SEXP);

/* Tail */
extern SEXP c_ts_node_symbol(SEXP);
extern SEXP c_ts_node_grammar_symbol(SEXP);
extern SEXP c_ts_node_parse_state(SEXP);
extern SEXP c_ts_node_next_parse_state(SEXP);
extern SEXP c_ts_node_child_by_field_id(SEXP, SEXP);
extern SEXP c_ts_node_field_name_for_child(SEXP, SEXP);
extern SEXP c_ts_node_field_name_for_named_child(SEXP, SEXP);
extern SEXP c_ts_node_first_child_for_byte(SEXP, SEXP);
extern SEXP c_ts_node_first_named_child_for_byte(SEXP, SEXP);
extern SEXP c_ts_node_descendant_for_byte_range(SEXP, SEXP, SEXP);
extern SEXP c_ts_node_named_descendant_for_byte_range(SEXP, SEXP, SEXP);
extern SEXP c_ts_node_descendant_for_point_range(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP c_ts_node_named_descendant_for_point_range(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP c_ts_language_state_count(SEXP);
extern SEXP c_ts_language_next_state(SEXP, SEXP, SEXP);
extern SEXP c_ts_query_start_byte_for_pattern(SEXP, SEXP);
extern SEXP c_ts_query_end_byte_for_pattern(SEXP, SEXP);
extern SEXP c_ts_query_matches(SEXP, SEXP);
extern SEXP c_ts_tree_included_ranges(SEXP);
extern SEXP c_ts_tree_root_node_with_offset(SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    /* Parser */
    {"c_ts_parser_new",              (DL_FUNC) &c_ts_parser_new,              0},
    {"c_ts_parser_set_language",     (DL_FUNC) &c_ts_parser_set_language,     2},
    {"c_ts_parse",                   (DL_FUNC) &c_ts_parse,                   4},
    {"c_ts_parser_set_included_ranges",(DL_FUNC) &c_ts_parser_set_included_ranges,7},
    {"c_ts_reparse",                 (DL_FUNC) &c_ts_reparse,                 13},
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
    /* Query */
    {"c_ts_query_new",               (DL_FUNC) &c_ts_query_new,               2},
    {"c_ts_query_capture_names",     (DL_FUNC) &c_ts_query_capture_names,     1},
    {"c_ts_query_pattern_count",     (DL_FUNC) &c_ts_query_pattern_count,     1},
    {"c_ts_query_capture_count",     (DL_FUNC) &c_ts_query_capture_count,     1},
    {"c_ts_query_string_count",      (DL_FUNC) &c_ts_query_string_count,      1},
    {"c_ts_query_captures",          (DL_FUNC) &c_ts_query_captures,          2},
    /* Introspection */
    {"c_ts_node_has_error",          (DL_FUNC) &c_ts_node_has_error,          1},
    {"c_ts_node_is_error",           (DL_FUNC) &c_ts_node_is_error,           1},
    {"c_ts_node_is_missing",         (DL_FUNC) &c_ts_node_is_missing,         1},
    {"c_ts_node_is_extra",           (DL_FUNC) &c_ts_node_is_extra,           1},
    {"c_ts_node_descendant_count",   (DL_FUNC) &c_ts_node_descendant_count,   1},
    {"c_ts_node_grammar_type",       (DL_FUNC) &c_ts_node_grammar_type,       1},
    {"c_ts_language_symbol_count",   (DL_FUNC) &c_ts_language_symbol_count,   1},
    {"c_ts_language_symbol_name",    (DL_FUNC) &c_ts_language_symbol_name,    2},
    {"c_ts_language_symbol_for_name",(DL_FUNC) &c_ts_language_symbol_for_name,3},
    {"c_ts_language_field_count",    (DL_FUNC) &c_ts_language_field_count,    1},
    {"c_ts_language_field_name_for_id",(DL_FUNC) &c_ts_language_field_name_for_id,2},
    {"c_ts_language_field_id_for_name",(DL_FUNC) &c_ts_language_field_id_for_name,2},
    /* Tail */
    {"c_ts_node_symbol",             (DL_FUNC) &c_ts_node_symbol,             1},
    {"c_ts_node_grammar_symbol",     (DL_FUNC) &c_ts_node_grammar_symbol,     1},
    {"c_ts_node_parse_state",        (DL_FUNC) &c_ts_node_parse_state,        1},
    {"c_ts_node_next_parse_state",   (DL_FUNC) &c_ts_node_next_parse_state,   1},
    {"c_ts_node_child_by_field_id",  (DL_FUNC) &c_ts_node_child_by_field_id,  2},
    {"c_ts_node_field_name_for_child",(DL_FUNC) &c_ts_node_field_name_for_child,2},
    {"c_ts_node_field_name_for_named_child",(DL_FUNC) &c_ts_node_field_name_for_named_child,2},
    {"c_ts_node_first_child_for_byte",(DL_FUNC) &c_ts_node_first_child_for_byte,2},
    {"c_ts_node_first_named_child_for_byte",(DL_FUNC) &c_ts_node_first_named_child_for_byte,2},
    {"c_ts_node_descendant_for_byte_range",(DL_FUNC) &c_ts_node_descendant_for_byte_range,3},
    {"c_ts_node_named_descendant_for_byte_range",(DL_FUNC) &c_ts_node_named_descendant_for_byte_range,3},
    {"c_ts_node_descendant_for_point_range",(DL_FUNC) &c_ts_node_descendant_for_point_range,5},
    {"c_ts_node_named_descendant_for_point_range",(DL_FUNC) &c_ts_node_named_descendant_for_point_range,5},
    {"c_ts_language_state_count",    (DL_FUNC) &c_ts_language_state_count,    1},
    {"c_ts_language_next_state",     (DL_FUNC) &c_ts_language_next_state,     3},
    {"c_ts_query_start_byte_for_pattern",(DL_FUNC) &c_ts_query_start_byte_for_pattern,2},
    {"c_ts_query_end_byte_for_pattern",(DL_FUNC) &c_ts_query_end_byte_for_pattern,2},
    {"c_ts_query_matches",           (DL_FUNC) &c_ts_query_matches,           2},
    {"c_ts_tree_included_ranges",    (DL_FUNC) &c_ts_tree_included_ranges,    1},
    {"c_ts_tree_root_node_with_offset",(DL_FUNC) &c_ts_tree_root_node_with_offset,4},
    {NULL, NULL, 0}
};

void R_init_bonsaisitter(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
