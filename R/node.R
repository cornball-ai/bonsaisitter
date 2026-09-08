# tree_sitter_node = list(raw, tree). The `raw` is the packed TSNode; the `tree`
# keeps the source (for text) and language alive. All node_*() functions are
# 1-indexed, matching treesitter.

new_node <- function(raw, tree) {
    out <- list(raw = raw, tree = tree)
    class(out) <- "tree_sitter_node"
    out
}

# Wrap a bare raw (or NULL) coming back from C into a node (or NULL).
wrap_node <- function(raw, tree) {
    if (is.null(raw)) {
        return(NULL)
    }
    new_node(raw, tree)
}

node_raw <- function(x) {
    .subset2(x, "raw")
}

node_tree <- function(x) {
    .subset2(x, "tree")
}

#' Is \code{x} a node?
#'
#' @param x An object.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x + 1", treesitter.r::language()))
#'   c(is_node(node), is_node("x + 1"))
#' }
#' @export
is_node <- function(x) {
    inherits(x, "tree_sitter_node")
}

#' The type of a node
#'
#' @param x A \code{tree_sitter_node}.
#' @return A single string.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x + 1", treesitter.r::language()))
#'   node_type(node)
#' }
#' @export
node_type <- function(x) {
    check_node(x)
    .Call(c_ts_node_type, node_raw(x))
}

#' The text underlying a node
#'
#' @param x A \code{tree_sitter_node}.
#' @return A single string.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- f(1)", treesitter.r::language()))
#'   node_text(node_child(node, 1))
#' }
#' @export
node_text <- function(x) {
    check_node(x)
    .Call(c_ts_node_text, node_raw(x), tree_text0(node_tree(x)))
}

#' Is a node named?
#'
#' @param x A \code{tree_sitter_node}.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   expr <- node_child(tree_root_node(tree), 1)
#'   vapply(node_children(expr), node_is_named, logical(1))
#' }
#' @export
node_is_named <- function(x) {
    check_node(x)
    .Call(c_ts_node_is_named, node_raw(x))
}

#' A node's start / end point
#'
#' @param x A \code{tree_sitter_node}.
#' @return A \code{tree_sitter_point}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1\ny <- 2", treesitter.r::language()))
#'   node_start_point(node)
#'   node_end_point(node)
#' }
#' @rdname node-points
#' @export
node_start_point <- function(x) {
    check_node(x)
    p <- .Call(c_ts_node_start_point, node_raw(x))
    new_point(as.double(p[["row"]]), as.double(p[["column"]]))
}

#' @rdname node-points
#' @export
node_end_point <- function(x) {
    check_node(x)
    p <- .Call(c_ts_node_end_point, node_raw(x))
    new_point(as.double(p[["row"]]), as.double(p[["column"]]))
}

#' A node's start / end byte
#'
#' @param x A \code{tree_sitter_node}.
#' @return A single double (0-indexed).
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   c(node_start_byte(node), node_end_byte(node))
#' }
#' @rdname node-bytes
#' @export
node_start_byte <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_start_byte, node_raw(x)))
}

#' @rdname node-bytes
#' @export
node_end_byte <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_end_byte, node_raw(x)))
}

#' A node's range
#'
#' @param x A \code{tree_sitter_node}.
#' @return A \code{tree_sitter_range}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   node_range(node)
#' }
#' @export
node_range <- function(x) {
    check_node(x)
    new_range(node_start_byte(x), node_start_point(x), node_end_byte(x),
              node_end_point(x))
}

#' Child counts
#'
#' @param x A \code{tree_sitter_node}.
#' @return A single double.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   expr <- node_child(tree_root_node(tree), 1)
#'   c(node_child_count(expr), node_named_child_count(expr))
#' }
#' @rdname node-child-count
#' @export
node_child_count <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_child_count, node_raw(x)))
}

#' @rdname node-child-count
#' @export
node_named_child_count <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_named_child_count, node_raw(x)))
}

#' Access a child by index (1-indexed)
#'
#' @param x A \code{tree_sitter_node}.
#' @param i A 1-indexed child position.
#' @return A \code{tree_sitter_node}, or \code{NULL}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   expr <- node_child(tree_root_node(tree), 1)
#'   c(node_type(node_child(expr, 2)), node_type(node_named_child(expr, 2)))
#' }
#' @rdname node-child
#' @export
node_child <- function(x, i) {
    check_node(x)
    wrap_node(.Call(c_ts_node_child, node_raw(x), as.integer(i) - 1L),
              node_tree(x))
}

#' @rdname node-child
#' @export
node_named_child <- function(x, i) {
    check_node(x)
    wrap_node(.Call(c_ts_node_named_child, node_raw(x), as.integer(i) - 1L),
              node_tree(x))
}

#' All children of a node
#'
#' @param x A \code{tree_sitter_node}.
#' @return A list of \code{tree_sitter_node}s.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   expr <- node_child(tree_root_node(tree), 1)
#'   vapply(node_children(expr), node_type, character(1))
#'   vapply(node_named_children(expr), node_type, character(1))
#' }
#' @rdname node-children
#' @export
node_children <- function(x) {
    check_node(x)
    lapply(.Call(c_ts_node_children, node_raw(x), FALSE), new_node,
           tree = node_tree(x))
}

#' @rdname node-children
#' @export
node_named_children <- function(x) {
    check_node(x)
    lapply(.Call(c_ts_node_children, node_raw(x), TRUE), new_node,
           tree = node_tree(x))
}

#' A child by field name
#'
#' @param x A \code{tree_sitter_node}.
#' @param name A field name.
#' @return A \code{tree_sitter_node}, or \code{NULL}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   expr <- node_child(tree_root_node(tree), 1)
#'   node_text(node_child_by_field_name(expr, "lhs"))
#' }
#' @export
node_child_by_field_name <- function(x, name) {
    check_node(x)
    wrap_node(.Call(c_ts_node_child_by_field, node_raw(x), as.character(name)),
              node_tree(x))
}

#' Sibling and parent navigation
#'
#' @param x A \code{tree_sitter_node}.
#' @return A \code{tree_sitter_node}, or \code{NULL}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   lhs <- node_child_by_field_name(node_child(tree_root_node(tree), 1), "lhs")
#'   c(node_type(node_parent(lhs)), node_type(node_next_sibling(lhs)),
#'     node_type(node_next_named_sibling(lhs)))
#' }
#' @rdname node-navigation
#' @export
node_parent <- function(x) {
    check_node(x)
    wrap_node(.Call(c_ts_node_parent, node_raw(x)), node_tree(x))
}

#' @rdname node-navigation
#' @export
node_next_sibling <- function(x) {
    check_node(x)
    wrap_node(.Call(c_ts_node_next_sibling, node_raw(x)), node_tree(x))
}

#' @rdname node-navigation
#' @export
node_previous_sibling <- function(x) {
    check_node(x)
    wrap_node(.Call(c_ts_node_prev_sibling, node_raw(x)), node_tree(x))
}

#' @rdname node-navigation
#' @export
node_next_named_sibling <- function(x) {
    check_node(x)
    wrap_node(.Call(c_ts_node_next_named_sibling, node_raw(x)), node_tree(x))
}

#' @rdname node-navigation
#' @export
node_previous_named_sibling <- function(x) {
    check_node(x)
    wrap_node(.Call(c_ts_node_prev_named_sibling, node_raw(x)), node_tree(x))
}

#' The raw s-expression of a node
#'
#' @param x A \code{tree_sitter_node}.
#' @return A single string.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   node_raw_s_expression(node)
#' }
#' @export
node_raw_s_expression <- function(x) {
    check_node(x)
    .Call(c_ts_node_sexpr, node_raw(x))
}

#' Show a node's s-expression
#'
#' @param x A \code{tree_sitter_node}.
#' @return \code{x}, invisibly, called for its side effect of printing.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   node_show_s_expression(node)
#' }
#' @export
node_show_s_expression <- function(x) {
    check_node(x)
    cat_line(node_raw_s_expression(x))
    invisible(x)
}

#' @export
print.tree_sitter_node <- function(x, ...) {
    cat_line("<tree_sitter_node>")
    cat_line(node_raw_s_expression(x))
    invisible(x)
}

check_node <- function(x, arg = "x") {
    check_inherits(x, "tree_sitter_node", arg)
}
