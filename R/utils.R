# bonsaisitter extras beyond the treesitter API surface.

#' Convert a node's descendants to a data frame
#'
#' @param x A `tree_sitter_node`.
#' @param row.names Ignored.
#' @param optional Ignored.
#' @param ... Ignored.
#' @return A base data frame with columns: type, named, text, start_row,
#'   start_col, end_row, end_col, start_byte, end_byte.
#' @export
as.data.frame.tree_sitter_node <- function(x, row.names = NULL,
    optional = FALSE, ...) {
    .Call(c_ts_node_descendants_df, node_raw(x), tree_text0(node_tree(x)))
}
