#' Create a new tree cursor
#'
#' A tree cursor allows efficient traversal of a syntax tree.
#'
#' @param node A \code{ts_node} to start from.
#' @return A \code{ts_cursor} object (external pointer).
#' @export
ts_cursor_new <- function(node) {
    tree <- attr(node, "tree")
    .Call(c_ts_cursor_new, node, tree)
}

#' Get the current node of a cursor
#'
#' @param cursor A \code{ts_cursor} object.
#' @return A \code{ts_node} object.
#' @export
ts_cursor_node <- function(cursor) {
    .Call(c_ts_cursor_node, cursor)
}

#' Move cursor to first child
#'
#' @param cursor A \code{ts_cursor} object.
#' @return \code{TRUE} if moved, \code{FALSE} if no children.
#' @export
ts_cursor_goto_first_child <- function(cursor) {
    .Call(c_ts_cursor_goto_first_child, cursor)
}

#' Move cursor to next sibling
#'
#' @param cursor A \code{ts_cursor} object.
#' @return \code{TRUE} if moved, \code{FALSE} if no next sibling.
#' @export
ts_cursor_goto_next_sibling <- function(cursor) {
    .Call(c_ts_cursor_goto_next_sibling, cursor)
}

#' Move cursor to parent
#'
#' @param cursor A \code{ts_cursor} object.
#' @return \code{TRUE} if moved, \code{FALSE} if at root.
#' @export
ts_cursor_goto_parent <- function(cursor) {
    .Call(c_ts_cursor_goto_parent, cursor)
}

#' Get field name at cursor position
#'
#' @param cursor A \code{ts_cursor} object.
#' @return A character string or \code{NA} if no field.
#' @export
ts_cursor_field_name <- function(cursor) {
    .Call(c_ts_cursor_field_name, cursor)
}

#' Get cursor depth
#'
#' @param cursor A \code{ts_cursor} object.
#' @return Integer depth relative to the cursor's root node.
#' @export
ts_cursor_depth <- function(cursor) {
    .Call(c_ts_cursor_depth, cursor)
}
