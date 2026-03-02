##' @export
print.ts_tree <- function(x, ...) {
    root <- ts_tree_root_node(x)
    n <- ts_node_child_count(root)
    src <- ts_tree_text(x)
    nchars <- nchar(src)
    cat(sprintf("<ts_tree> %d top-level children, %d bytes\n", n, nchars))
    invisible(x)
}

##' @export
print.ts_node <- function(x, ...) {
    type <- ts_node_type(x)
    sp <- ts_node_start_point(x)
    ep <- ts_node_end_point(x)
    named <- if (ts_node_is_named(x)) "named" else "anonymous"
    n <- ts_node_child_count(x)
    cat(sprintf("<ts_node> %s (%s) [%d:%d - %d:%d] %d children\n",
                type, named, sp[1], sp[2], ep[1], ep[2], n))
    invisible(x)
}

##' @export
print.ts_cursor <- function(x, ...) {
    node <- ts_cursor_node(x)
    depth <- ts_cursor_depth(x)
    type <- ts_node_type(node)
    cat(sprintf("<ts_cursor> at '%s', depth %d\n", type, depth))
    invisible(x)
}

##' Convert a node to a data frame of descendants
##'
##' @param x A \code{ts_node} object.
##' @param row.names Ignored.
##' @param optional Ignored.
##' @param ... Ignored.
##' @return A data frame with columns: type, named, text, start_row,
##'   start_col, end_row, end_col, start_byte, end_byte.
##' @export
as.data.frame.ts_node <- function(x, row.names = NULL, optional = FALSE, ...) {
    tree <- attr(x, "tree")
    .Call(c_ts_node_descendants_df, x, tree[["source"]])
}
