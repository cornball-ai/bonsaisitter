# tree_sitter_tree = list(pointer, text, language).

new_tree <- function(pointer, text, language) {
    out <- list(pointer = pointer, text = text, language = language)
    class(out) <- "tree_sitter_tree"
    out
}

#' Retrieve the root node of a tree
#'
#' @param x A `tree_sitter_tree`.
#' @return A `tree_sitter_node`.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   node_type(tree_root_node(tree))
#' }
#' @export
tree_root_node <- function(x) {
    check_tree(x)
    raw <- .Call(c_ts_tree_root_node, tree_pointer(x))
    new_node(raw, x)
}

#' Tree accessors
#'
#' @description
#' - `tree_text()` returns the text the tree was parsed with.
#' - `tree_language()` returns the tree's `tree_sitter_language`.
#'
#' @param x A `tree_sitter_tree`.
#' @return `tree_text()` a string; `tree_language()` a language.
#' @rdname tree-accessors
#' @export
tree_text <- function(x) {
    check_tree(x)
    tree_text0(x)
}

#' @rdname tree-accessors
#' @export
tree_language <- function(x) {
    check_tree(x)
    tree_language0(x)
}

#' Is `x` a tree?
#'
#' @param x An object.
#' @return `TRUE` or `FALSE`.
#' @export
is_tree <- function(x) {
    inherits(x, "tree_sitter_tree")
}

#' @export
print.tree_sitter_tree <- function(x, ...) {
    root <- tree_root_node(x)
    cat_line("<tree_sitter_tree>")
    cat_line(node_raw_s_expression(root))
    invisible(x)
}

tree_pointer <- function(x) {
    .subset2(x, "pointer")
}

tree_text0 <- function(x) {
    .subset2(x, "text")
}

tree_language0 <- function(x) {
    .subset2(x, "language")
}

check_tree <- function(x, arg = "x") {
    check_inherits(x, "tree_sitter_tree", arg)
}
