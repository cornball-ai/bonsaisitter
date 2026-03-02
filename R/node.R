##' Get the type of a node
##'
##' @param node A \code{ts_node} object.
##' @return A character string.
##' @export
ts_node_type <- function(node) {
    .Call(c_ts_node_type, node)
}

##' Get the text of a node
##'
##' @param node A \code{ts_node} object.
##' @return A character string.
##' @export
ts_node_text <- function(node) {
    tree <- attr(node, "tree")
    .Call(c_ts_node_text, node, tree[["source"]])
}

##' Check if a node is named
##'
##' Named nodes correspond to named rules in the grammar.
##' Anonymous nodes correspond to string literals.
##'
##' @param node A \code{ts_node} object.
##' @return Logical.
##' @export
ts_node_is_named <- function(node) {
    .Call(c_ts_node_is_named, node)
}

##' Check if a node is null
##'
##' @param node A \code{ts_node} object.
##' @return Logical.
##' @export
ts_node_is_null <- function(node) {
    if (is.null(node)) return(TRUE)
    .Call(c_ts_node_is_null, node)
}

##' Get the start position of a node
##'
##' @param node A \code{ts_node} object.
##' @return Named integer vector with \code{row} and \code{column} (0-based).
##' @export
ts_node_start_point <- function(node) {
    .Call(c_ts_node_start_point, node)
}

##' Get the end position of a node
##'
##' @param node A \code{ts_node} object.
##' @return Named integer vector with \code{row} and \code{column} (0-based).
##' @export
ts_node_end_point <- function(node) {
    .Call(c_ts_node_end_point, node)
}

##' Get the start byte offset of a node
##'
##' @param node A \code{ts_node} object.
##' @return Integer.
##' @export
ts_node_start_byte <- function(node) {
    .Call(c_ts_node_start_byte, node)
}

##' Get the end byte offset of a node
##'
##' @param node A \code{ts_node} object.
##' @return Integer.
##' @export
ts_node_end_byte <- function(node) {
    .Call(c_ts_node_end_byte, node)
}

##' Get the parent of a node
##'
##' @param node A \code{ts_node} object.
##' @return A \code{ts_node} or \code{NULL} if at the root.
##' @export
ts_node_parent <- function(node) {
    .Call(c_ts_node_parent, node)
}

##' Get a child of a node by index
##'
##' @param node A \code{ts_node} object.
##' @param i Zero-based child index.
##' @return A \code{ts_node} or \code{NULL}.
##' @export
ts_node_child <- function(node, i) {
    .Call(c_ts_node_child, node, as.integer(i))
}

##' Get the number of children of a node
##'
##' @param node A \code{ts_node} object.
##' @return Integer.
##' @export
ts_node_child_count <- function(node) {
    .Call(c_ts_node_child_count, node)
}

##' Get a named child of a node by index
##'
##' @param node A \code{ts_node} object.
##' @param i Zero-based index among named children only.
##' @return A \code{ts_node} or \code{NULL}.
##' @export
ts_node_named_child <- function(node, i) {
    .Call(c_ts_node_named_child, node, as.integer(i))
}

##' Get the number of named children of a node
##'
##' @param node A \code{ts_node} object.
##' @return Integer.
##' @export
ts_node_named_child_count <- function(node) {
    .Call(c_ts_node_named_child_count, node)
}

##' Get all children of a node
##'
##' @param node A \code{ts_node} object.
##' @param named If \code{TRUE}, return only named children.
##' @return A list of \code{ts_node} objects.
##' @export
ts_node_children <- function(node, named = FALSE) {
    .Call(c_ts_node_children, node, as.logical(named))
}

##' Get the next sibling of a node
##'
##' @param node A \code{ts_node} object.
##' @return A \code{ts_node} or \code{NULL}.
##' @export
ts_node_next_sibling <- function(node) {
    .Call(c_ts_node_next_sibling, node)
}

##' Get the previous sibling of a node
##'
##' @param node A \code{ts_node} object.
##' @return A \code{ts_node} or \code{NULL}.
##' @export
ts_node_prev_sibling <- function(node) {
    .Call(c_ts_node_prev_sibling, node)
}

##' Get the next named sibling of a node
##'
##' @param node A \code{ts_node} object.
##' @return A \code{ts_node} or \code{NULL}.
##' @export
ts_node_next_named_sibling <- function(node) {
    .Call(c_ts_node_next_named_sibling, node)
}

##' Get the previous named sibling of a node
##'
##' @param node A \code{ts_node} object.
##' @return A \code{ts_node} or \code{NULL}.
##' @export
ts_node_prev_named_sibling <- function(node) {
    .Call(c_ts_node_prev_named_sibling, node)
}

##' Get a child node by field name
##'
##' @param node A \code{ts_node} object.
##' @param name Field name as a character string.
##' @return A \code{ts_node} or \code{NULL}.
##' @export
ts_node_child_by_field <- function(node, name) {
    .Call(c_ts_node_child_by_field, node, as.character(name))
}

##' Get the S-expression representation of a node
##'
##' @param node A \code{ts_node} object.
##' @return A character string.
##' @export
ts_node_sexpr <- function(node) {
    .Call(c_ts_node_sexpr, node)
}
