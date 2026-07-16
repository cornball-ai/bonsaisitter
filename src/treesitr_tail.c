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
    if (ts_node_is_null(node)) return R_NilValue;
    SEXP raw = PROTECT(Rf_allocVector(RAWSXP, sizeof(TSNode)));
    memcpy(RAW(raw), &node, sizeof(TSNode));
    UNPROTECT(1);
    return raw;
}

/* ---- Node: symbols, parse states ---- */

SEXP c_ts_node_symbol(SEXP node_raw) {
    return Rf_ScalarInteger((int)ts_node_symbol(raw_to_node(node_raw)));
}

SEXP c_ts_node_grammar_symbol(SEXP node_raw) {
    return Rf_ScalarInteger((int)ts_node_grammar_symbol(raw_to_node(node_raw)));
}

SEXP c_ts_node_parse_state(SEXP node_raw) {
    return Rf_ScalarInteger((int)ts_node_parse_state(raw_to_node(node_raw)));
}

SEXP c_ts_node_next_parse_state(SEXP node_raw) {
    return Rf_ScalarInteger((int)ts_node_next_parse_state(raw_to_node(node_raw)));
}

/* ---- Node: field-by-id and field names ---- */

SEXP c_ts_node_child_by_field_id(SEXP node_raw, SEXP field_id) {
    TSNode node = raw_to_node(node_raw);
    TSNode out = ts_node_child_by_field_id(node, (TSFieldId)Rf_asInteger(field_id));
    return node_as_raw(out);
}

/* `index` is 0-indexed here; the R layer converts from 1-indexed. */
SEXP c_ts_node_field_name_for_child(SEXP node_raw, SEXP index) {
    const char *name = ts_node_field_name_for_child(raw_to_node(node_raw),
                                                     (uint32_t)Rf_asInteger(index));
    if (!name) return Rf_ScalarString(NA_STRING);
    return Rf_ScalarString(Rf_mkCharCE(name, CE_UTF8));
}

SEXP c_ts_node_field_name_for_named_child(SEXP node_raw, SEXP index) {
    const char *name = ts_node_field_name_for_named_child(raw_to_node(node_raw),
                                                          (uint32_t)Rf_asInteger(index));
    if (!name) return Rf_ScalarString(NA_STRING);
    return Rf_ScalarString(Rf_mkCharCE(name, CE_UTF8));
}

/* ---- Node: byte/point lookups ---- */

SEXP c_ts_node_first_child_for_byte(SEXP node_raw, SEXP byte) {
    TSNode out = ts_node_first_child_for_byte(raw_to_node(node_raw),
                                              (uint32_t)Rf_asInteger(byte));
    return node_as_raw(out);
}

SEXP c_ts_node_first_named_child_for_byte(SEXP node_raw, SEXP byte) {
    TSNode out = ts_node_first_named_child_for_byte(raw_to_node(node_raw),
                                                    (uint32_t)Rf_asInteger(byte));
    return node_as_raw(out);
}

SEXP c_ts_node_descendant_for_byte_range(SEXP node_raw, SEXP start, SEXP end) {
    TSNode out = ts_node_descendant_for_byte_range(raw_to_node(node_raw),
        (uint32_t)Rf_asInteger(start), (uint32_t)Rf_asInteger(end));
    return node_as_raw(out);
}

SEXP c_ts_node_named_descendant_for_byte_range(SEXP node_raw, SEXP start, SEXP end) {
    TSNode out = ts_node_named_descendant_for_byte_range(raw_to_node(node_raw),
        (uint32_t)Rf_asInteger(start), (uint32_t)Rf_asInteger(end));
    return node_as_raw(out);
}

SEXP c_ts_node_descendant_for_point_range(SEXP node_raw, SEXP sr, SEXP sc, SEXP er, SEXP ec) {
    TSPoint sp = {(uint32_t)Rf_asInteger(sr), (uint32_t)Rf_asInteger(sc)};
    TSPoint ep = {(uint32_t)Rf_asInteger(er), (uint32_t)Rf_asInteger(ec)};
    TSNode out = ts_node_descendant_for_point_range(raw_to_node(node_raw), sp, ep);
    return node_as_raw(out);
}

SEXP c_ts_node_named_descendant_for_point_range(SEXP node_raw, SEXP sr, SEXP sc, SEXP er, SEXP ec) {
    TSPoint sp = {(uint32_t)Rf_asInteger(sr), (uint32_t)Rf_asInteger(sc)};
    TSPoint ep = {(uint32_t)Rf_asInteger(er), (uint32_t)Rf_asInteger(ec)};
    TSNode out = ts_node_named_descendant_for_point_range(raw_to_node(node_raw), sp, ep);
    return node_as_raw(out);
}

/* ---- Language: states ---- */

SEXP c_ts_language_state_count(SEXP language_ptr) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    return Rf_ScalarInteger((int)ts_language_state_count(lang));
}

SEXP c_ts_language_next_state(SEXP language_ptr, SEXP state, SEXP symbol) {
    const TSLanguage *lang = (const TSLanguage *)R_ExternalPtrAddr(language_ptr);
    TSStateId out = ts_language_next_state(lang, (TSStateId)Rf_asInteger(state),
                                           (TSSymbol)Rf_asInteger(symbol));
    return Rf_ScalarInteger((int)out);
}

/* ---- Query: byte-for-pattern, matches ---- */

SEXP c_ts_query_start_byte_for_pattern(SEXP query_ptr, SEXP i) {
    TSQuery *q = (TSQuery *)R_ExternalPtrAddr(query_ptr);
    return Rf_ScalarInteger((int)ts_query_start_byte_for_pattern(q, (uint32_t)Rf_asInteger(i)));
}

SEXP c_ts_query_end_byte_for_pattern(SEXP query_ptr, SEXP i) {
    TSQuery *q = (TSQuery *)R_ExternalPtrAddr(query_ptr);
    return Rf_ScalarInteger((int)ts_query_end_byte_for_pattern(q, (uint32_t)Rf_asInteger(i)));
}

/* Returns a flat list of matches; each match is
   list(pattern = double, name = character, node = list of bare raws). */
SEXP c_ts_query_matches(SEXP query_ptr, SEXP node_raw) {
    TSQuery *q = (TSQuery *)R_ExternalPtrAddr(query_ptr);
    TSNode node = raw_to_node(node_raw);

    TSQueryCursor *cursor = ts_query_cursor_new();
    TSQueryMatch match;

    ts_query_cursor_exec(cursor, q, node);
    uint32_t nmatch = 0;
    while (ts_query_cursor_next_match(cursor, &match)) nmatch++;

    SEXP out = PROTECT(Rf_allocVector(VECSXP, nmatch));
    SEXP match_names = PROTECT(Rf_allocVector(STRSXP, 3));
    SET_STRING_ELT(match_names, 0, Rf_mkChar("pattern"));
    SET_STRING_ELT(match_names, 1, Rf_mkChar("name"));
    SET_STRING_ELT(match_names, 2, Rf_mkChar("node"));

    ts_query_cursor_exec(cursor, q, node);
    uint32_t mi = 0;
    while (ts_query_cursor_next_match(cursor, &match) && mi < nmatch) {
        uint32_t nc = match.capture_count;
        SEXP names = PROTECT(Rf_allocVector(STRSXP, nc));
        SEXP nodes = PROTECT(Rf_allocVector(VECSXP, nc));
        for (uint32_t c = 0; c < nc; c++) {
            TSQueryCapture cap = match.captures[c];
            uint32_t len = 0;
            const char *nm = ts_query_capture_name_for_id(q, cap.index, &len);
            SET_STRING_ELT(names, c, Rf_mkCharLenCE(nm, (int)len, CE_UTF8));
            SET_VECTOR_ELT(nodes, c, node_as_raw(cap.node));
        }
        SEXP m = PROTECT(Rf_allocVector(VECSXP, 3));
        SET_VECTOR_ELT(m, 0, Rf_ScalarReal((double)match.pattern_index));
        SET_VECTOR_ELT(m, 1, names);
        SET_VECTOR_ELT(m, 2, nodes);
        Rf_setAttrib(m, R_NamesSymbol, match_names);
        SET_VECTOR_ELT(out, mi, m);
        UNPROTECT(3);
        mi++;
    }
    ts_query_cursor_delete(cursor);

    UNPROTECT(2);
    return out;
}

/* ---- Tree: included ranges, offset root ---- */

/* Returns list(start_byte, start_row, start_col, end_byte, end_row, end_col). */
SEXP c_ts_tree_included_ranges(SEXP tree_ptr) {
    TSTree *tree = (TSTree *)R_ExternalPtrAddr(tree_ptr);
    uint32_t n = 0;
    TSRange *ranges = ts_tree_included_ranges(tree, &n);

    SEXP sb = PROTECT(Rf_allocVector(REALSXP, n));
    SEXP sr = PROTECT(Rf_allocVector(REALSXP, n));
    SEXP sc = PROTECT(Rf_allocVector(REALSXP, n));
    SEXP eb = PROTECT(Rf_allocVector(REALSXP, n));
    SEXP er = PROTECT(Rf_allocVector(REALSXP, n));
    SEXP ec = PROTECT(Rf_allocVector(REALSXP, n));
    for (uint32_t i = 0; i < n; i++) {
        REAL(sb)[i] = ranges[i].start_byte;
        REAL(sr)[i] = ranges[i].start_point.row;
        REAL(sc)[i] = ranges[i].start_point.column;
        REAL(eb)[i] = ranges[i].end_byte;
        REAL(er)[i] = ranges[i].end_point.row;
        REAL(ec)[i] = ranges[i].end_point.column;
    }
    free(ranges);

    SEXP out = PROTECT(Rf_allocVector(VECSXP, 6));
    SET_VECTOR_ELT(out, 0, sb);
    SET_VECTOR_ELT(out, 1, sr);
    SET_VECTOR_ELT(out, 2, sc);
    SET_VECTOR_ELT(out, 3, eb);
    SET_VECTOR_ELT(out, 4, er);
    SET_VECTOR_ELT(out, 5, ec);
    UNPROTECT(7);
    return out;
}

SEXP c_ts_tree_root_node_with_offset(SEXP tree_ptr, SEXP byte, SEXP row, SEXP col) {
    TSTree *tree = (TSTree *)R_ExternalPtrAddr(tree_ptr);
    TSPoint extent = {(uint32_t)Rf_asInteger(row), (uint32_t)Rf_asInteger(col)};
    TSNode out = ts_tree_root_node_with_offset(tree, (uint32_t)Rf_asInteger(byte), extent);
    return node_as_raw(out);
}
