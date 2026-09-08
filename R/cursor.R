# TreeCursor for efficient traversal. treesitter uses an R6 object with method
# calls (cur$goto_first_child()); we keep that exact call style in base R with an
# environment of closures, so it stays a drop-in without an R6 dependency. Class
# is "tree_sitter_tree_cursor" (no "R6" tag).

#' Walk a tree or node with a cursor
#'
#' @description
#' \code{tree_walk()} and \code{node_walk()} create a \code{tree_sitter_tree_cursor}, a mutable
#' cursor for efficient traversal. Navigate with its methods:
#' \code{cursor$goto_first_child()}, \code{cursor$goto_next_sibling()},
#' \code{cursor$goto_parent()} (each returns \code{TRUE}/\code{FALSE}), and read state with
#' \code{cursor$node()}, \code{cursor$field_name()}, and \code{cursor$depth()}.
#'
#' @param x A \code{tree_sitter_tree}.
#' @param node A \code{tree_sitter_node}.
#' @return A \code{tree_sitter_tree_cursor}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   cursor <- tree_walk(text_parse("x <- 1", treesitter.r::language()))
#'   cursor$goto_first_child()
#'   node_type(cursor$node())
#' }
#' @rdname tree-cursor
#' @export
tree_walk <- function(x) {
    check_tree(x)
    node_walk(tree_root_node(x))
}

#' @rdname tree-cursor
#' @export
node_walk <- function(node) {
    check_node(node)
    tree <- node_tree(node)
    ptr <- .Call(c_ts_cursor_new, node_raw(node), tree)

    self <- new.env(parent = emptyenv())
    self$node <- function() {
        new_node(.Call(c_ts_cursor_node, ptr), tree)
    }
    self$goto_first_child <- function() {
        .Call(c_ts_cursor_goto_first_child, ptr)
    }
    self$goto_next_sibling <- function() {
        .Call(c_ts_cursor_goto_next_sibling, ptr)
    }
    self$goto_parent <- function() {
        .Call(c_ts_cursor_goto_parent, ptr)
    }
    self$field_name <- function() {
        .Call(c_ts_cursor_field_name, ptr)
    }
    self$depth <- function() {
        as.double(.Call(c_ts_cursor_depth, ptr))
    }
    class(self) <- "tree_sitter_tree_cursor"
    self
}

#' Is \code{x} a tree cursor?
#'
#' @param x An object.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   is_tree_cursor(tree_walk(text_parse("x <- 1", treesitter.r::language())))
#' }
#' @export
is_tree_cursor <- function(x) {
    inherits(x, "tree_sitter_tree_cursor")
}

#' @export
print.tree_sitter_tree_cursor <- function(x, ...) {
    node <- x$node()
    cat_line("<tree_sitter_tree_cursor>")
    cat_line(sprintf("At: %s (depth %g)", node_type(node), x$depth()))
    invisible(x)
}
