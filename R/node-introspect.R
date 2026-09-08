# Node introspection: error/state predicates and grammar metadata.

#' Node error and state predicates
#'
#' @description
#' - \code{node_has_error()} is \code{TRUE} if the node or any descendant is an error or
#'   is missing.
#' - \code{node_is_error()} is \code{TRUE} if the node itself is a syntax error.
#' - \code{node_is_missing()} is \code{TRUE} if the node is inserted by the parser to
#'   recover from an error.
#' - \code{node_is_extra()} is \code{TRUE} if the node is "extra" (e.g. a comment).
#'
#' @param x A \code{tree_sitter_node}.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   lang <- treesitter.r::language()
#'   ok <- tree_root_node(text_parse("x <- 1", lang))
#'   broken <- tree_root_node(text_parse("x <- ", lang))
#'   c(node_has_error(ok), node_has_error(broken))
#' }
#' @rdname node-state
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
#' @param x A \code{tree_sitter_node}.
#' @return A single double, including the node itself.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   node_descendant_count(node)
#' }
#' @export
node_descendant_count <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_descendant_count, node_raw(x)))
}

#' The grammar type of a node
#'
#' Like \code{\link{node_type}}, but returns the type as written in the grammar, ignoring
#' aliases.
#'
#' @param x A \code{tree_sitter_node}.
#' @return A single string.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   node_grammar_type(node)
#' }
#' @export
node_grammar_type <- function(x) {
    check_node(x)
    .Call(c_ts_node_grammar_type, node_raw(x))
}

#' The language of a node
#'
#' @param x A \code{tree_sitter_node}.
#' @return A \code{tree_sitter_language}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   language_name(node_language(node))
#' }
#' @export
node_language <- function(x) {
    check_node(x)
    tree_language0(node_tree(x))
}
