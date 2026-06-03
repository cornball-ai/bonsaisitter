#' Get the root node of a syntax tree
#'
#' @param tree A \code{ts_tree} object from \code{\link{ts_parse}}.
#' @return A \code{ts_node} object.
#' @export
ts_tree_root_node <- function(tree) {
    .Call(c_ts_tree_root_node, tree)
}

#' Get the source text of a syntax tree
#'
#' @param tree A \code{ts_tree} object.
#' @return The source string that was parsed.
#' @export
ts_tree_text <- function(tree) {
    tree[["source"]]
}
