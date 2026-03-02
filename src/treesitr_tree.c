#include <R.h>
#include <Rinternals.h>
#include <string.h>
#include <tree_sitter/api.h>

static void tree_finalizer(SEXP ptr) {
    TSTree *tree = (TSTree *)R_ExternalPtrAddr(ptr);
    if (tree) {
        ts_tree_delete(tree);
        R_ClearExternalPtr(ptr);
    }
}

SEXP c_ts_tree_register_finalizer(SEXP tree_ptr) {
    R_RegisterCFinalizer(tree_ptr, tree_finalizer);
    return R_NilValue;
}

/* Returns a ts_node: raw vector of sizeof(TSNode) bytes,
   with attr "tree" pointing to the tree list for GC protection */
SEXP c_ts_tree_root_node(SEXP tree_obj) {
    SEXP tree_ptr = VECTOR_ELT(tree_obj, 0);
    TSTree *tree = (TSTree *)R_ExternalPtrAddr(tree_ptr);
    if (!tree) Rf_error("tree has been freed");

    TSNode root = ts_tree_root_node(tree);

    SEXP raw = PROTECT(Rf_allocVector(RAWSXP, sizeof(TSNode)));
    memcpy(RAW(raw), &root, sizeof(TSNode));
    Rf_setAttrib(raw, Rf_install("tree"), tree_obj);
    Rf_setAttrib(raw, R_ClassSymbol, Rf_mkString("ts_node"));
    UNPROTECT(1);
    return raw;
}
