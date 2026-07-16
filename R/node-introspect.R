# Node introspection: error/state predicates and grammar metadata.

#' Node error and state predicates
#'
#' @description
#' - `node_has_error()` is `TRUE` if the node or any descendant is an error or
#'   is missing.
#' - `node_is_error()` is `TRUE` if the node itself is a syntax error.
#' - `node_is_missing()` is `TRUE` if the node is inserted by the parser to
#'   recover from an error.
#' - `node_is_extra()` is `TRUE` if the node is "extra" (e.g. a comment).
#'
#' @param x A `tree_sitter_node`.
#' @return `TRUE` or `FALSE`.
#' @name node-state
#' @export
node_has_error <- function(x) {
    check_node(x)
    .Call(c_ts_node_has_error, node_raw(x))
}

#' @rdname node-state
#' @export
node_is_error <- function(x) {
    check_node(x)
    .Call(c_ts_node_is_error, node_raw(x))
}

#' @rdname node-state
#' @export
node_is_missing <- function(x) {
    check_node(x)
    .Call(c_ts_node_is_missing, node_raw(x))
}

#' @rdname node-state
#' @export
node_is_extra <- function(x) {
    check_node(x)
    .Call(c_ts_node_is_extra, node_raw(x))
}

#' The number of descendants of a node
#'
#' @param x A `tree_sitter_node`.
#' @return A single double, including the node itself.
#' @export
node_descendant_count <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_descendant_count, node_raw(x)))
}

#' The grammar type of a node
#'
#' Like [node_type()], but returns the type as written in the grammar, ignoring
#' aliases.
#'
#' @param x A `tree_sitter_node`.
#' @return A single string.
#' @export
node_grammar_type <- function(x) {
    check_node(x)
    .Call(c_ts_node_grammar_type, node_raw(x))
}

#' The language of a node
#'
#' @param x A `tree_sitter_node`.
#' @return A `tree_sitter_language`.
#' @export
node_language <- function(x) {
    check_node(x)
    tree_language0(node_tree(x))
}
