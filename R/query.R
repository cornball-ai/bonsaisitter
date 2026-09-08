# tree_sitter_query = list(pointer, capture_names, source, language).
# Predicate handling (#eq?, #match?, ...) and range restriction are not yet
# implemented; query_captures returns all captures a pattern produces.

new_query <- function(pointer, capture_names, source, language) {
    out <- list(pointer = pointer, capture_names = capture_names,
                source = source, language = language)
    class(out) <- "tree_sitter_query"
    out
}

#' Compile a tree-sitter query
#'
#' @param language A \code{tree_sitter_language}.
#' @param source A single string of query source (tree-sitter S-expression
#'   pattern syntax).
#' @return A \code{tree_sitter_query}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   q <- query(treesitter.r::language(), "(call function: (identifier) @fn)")
#'   query_capture_count(q)
#' }
#' @export
query <- function(language, source) {
    check_language(language)
    check_string(source, arg = "source")
    pointer <- .Call(c_ts_query_new, language_pointer(language), source)
    capture_names <- .Call(c_ts_query_capture_names, pointer)
    new_query(pointer, capture_names, source, language)
}

#' Run a query and collect its captures
#'
#' @param x A \code{tree_sitter_query}.
#' @param node A \code{tree_sitter_node} to search within.
#' @return A list with \code{name} (character vector of capture names) and \code{node}
#'   (list of \code{tree_sitter_node}s), one entry per capture in traversal order.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   lang <- treesitter.r::language()
#'   node <- tree_root_node(text_parse("f(1); g(2)", lang))
#'   q <- query(lang, "(call function: (identifier) @fn)")
#'   vapply(query_captures(q, node)$node, node_text, character(1))
#' }
#' @export
query_captures <- function(x, node) {
    check_query(x)
    check_node(node)
    out <- .Call(c_ts_query_captures, query_pointer0(x), node_raw(node))
    tree <- node_tree(node)
    list(name = out[["name"]],
         node = lapply(out[["node"]], new_node, tree = tree))
}

#' Query counts
#'
#' @param x A \code{tree_sitter_query}.
#' @return A single double.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   q <- query(treesitter.r::language(), "(call function: (identifier) @fn)")
#'   c(query_pattern_count(q), query_capture_count(q), query_string_count(q))
#' }
#' @rdname query-counts
#' @export
query_pattern_count <- function(x) {
    check_query(x)
    as.double(.Call(c_ts_query_pattern_count, query_pointer0(x)))
}

#' @rdname query-counts
#' @export
query_capture_count <- function(x) {
    check_query(x)
    as.double(.Call(c_ts_query_capture_count, query_pointer0(x)))
}

#' @rdname query-counts
#' @export
query_string_count <- function(x) {
    check_query(x)
    as.double(.Call(c_ts_query_string_count, query_pointer0(x)))
}

#' Is \code{x} a query?
#'
#' @param x An object.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   is_query(query(treesitter.r::language(), "(identifier) @id"))
#' }
#' @export
is_query <- function(x) {
    inherits(x, "tree_sitter_query")
}

#' @export
print.tree_sitter_query <- function(x, ...) {
    cat_line("<tree_sitter_query>")
    cat_line(sprintf("Captures: %s",
                     paste(.subset2(x, "capture_names"), collapse = ", ")))
    invisible(x)
}

query_pointer0 <- function(x) {
    .subset2(x, "pointer")
}

check_query <- function(x, arg = "x") {
    check_inherits(x, "tree_sitter_query", arg)
}
