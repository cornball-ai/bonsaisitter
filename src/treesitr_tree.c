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

/* Takes the tree's external pointer, returns the root node as a bare raw
   (sizeof(TSNode) bytes). The R layer wraps it into list(raw, tree). */
SEXP c_ts_tree_root_node(SEXP tree_ptr) {
    TSTree *tree = (TSTree *)R_ExternalPtrAddr(tree_ptr);
    if (!tree) Rf_error("tree has been freed");

    TSNode root = ts_tree_root_node(tree);

    SEXP raw = PROTECT(Rf_allocVector(RAWSXP, sizeof(TSNode)));
    memcpy(RAW(raw), &root, sizeof(TSNode));
    UNPROTECT(1);
    return raw;
}
