#include <R.h>
#include <Rinternals.h>
#include <string.h>
#include <tree_sitter/api.h>

static void cursor_finalizer(SEXP ptr) {
    TSTreeCursor *cursor = (TSTreeCursor *)R_ExternalPtrAddr(ptr);
    if (cursor) {
        ts_tree_cursor_delete(cursor);
        free(cursor);
        R_ClearExternalPtr(ptr);
    }
}

SEXP c_ts_cursor_new(SEXP node_raw, SEXP tree_obj) {
    TSNode node;
    memcpy(&node, RAW(node_raw), sizeof(TSNode));

    TSTreeCursor *cursor = (TSTreeCursor *)malloc(sizeof(TSTreeCursor));
    if (!cursor) Rf_error("failed to allocate cursor");
    *cursor = ts_tree_cursor_new(node);

    SEXP ptr = PROTECT(R_MakeExternalPtr(cursor, R_NilValue, tree_obj));
    R_RegisterCFinalizer(ptr, cursor_finalizer);
    Rf_setAttrib(ptr, Rf_install("tree"), tree_obj);
    Rf_setAttrib(ptr, R_ClassSymbol, Rf_mkString("ts_cursor"));
    UNPROTECT(1);
    return ptr;
}

SEXP c_ts_cursor_node(SEXP cursor_ptr) {
    TSTreeCursor *cursor = (TSTreeCursor *)R_ExternalPtrAddr(cursor_ptr);
    if (!cursor) Rf_error("cursor has been freed");

    TSNode node = ts_tree_cursor_current_node(cursor);
    SEXP tree_obj = Rf_getAttrib(cursor_ptr, Rf_install("tree"));

    SEXP raw = PROTECT(Rf_allocVector(RAWSXP, sizeof(TSNode)));
    memcpy(RAW(raw), &node, sizeof(TSNode));
    Rf_setAttrib(raw, Rf_install("tree"), tree_obj);
    Rf_setAttrib(raw, R_ClassSymbol, Rf_mkString("ts_node"));
    UNPROTECT(1);
    return raw;
}

SEXP c_ts_cursor_goto_first_child(SEXP cursor_ptr) {
    TSTreeCursor *cursor = (TSTreeCursor *)R_ExternalPtrAddr(cursor_ptr);
    if (!cursor) Rf_error("cursor has been freed");
    return Rf_ScalarLogical(ts_tree_cursor_goto_first_child(cursor));
}

SEXP c_ts_cursor_goto_next_sibling(SEXP cursor_ptr) {
    TSTreeCursor *cursor = (TSTreeCursor *)R_ExternalPtrAddr(cursor_ptr);
    if (!cursor) Rf_error("cursor has been freed");
    return Rf_ScalarLogical(ts_tree_cursor_goto_next_sibling(cursor));
}

SEXP c_ts_cursor_goto_parent(SEXP cursor_ptr) {
    TSTreeCursor *cursor = (TSTreeCursor *)R_ExternalPtrAddr(cursor_ptr);
    if (!cursor) Rf_error("cursor has been freed");
    return Rf_ScalarLogical(ts_tree_cursor_goto_parent(cursor));
}

SEXP c_ts_cursor_field_name(SEXP cursor_ptr) {
    TSTreeCursor *cursor = (TSTreeCursor *)R_ExternalPtrAddr(cursor_ptr);
    if (!cursor) Rf_error("cursor has been freed");
    const char *name = ts_tree_cursor_current_field_name(cursor);
    if (!name) return Rf_ScalarString(NA_STRING);
    return Rf_ScalarString(Rf_mkCharCE(name, CE_UTF8));
}

SEXP c_ts_cursor_depth(SEXP cursor_ptr) {
    TSTreeCursor *cursor = (TSTreeCursor *)R_ExternalPtrAddr(cursor_ptr);
    if (!cursor) Rf_error("cursor has been freed");
    return Rf_ScalarInteger((int)ts_tree_cursor_current_depth(cursor));
}
