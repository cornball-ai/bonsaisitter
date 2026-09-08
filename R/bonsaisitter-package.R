#' bonsaisitter: Bindings to the 'Tree-Sitter' Parsing Library
#'
#' A runtime for the tree-sitter parsing library that mirrors the API of the
#' treesitter package, so it can serve as a drop-in replacement. Grammars come
#' from separate packages such as treesitter.r. Parse text with
#' \code{\link{text_parse}} or \code{\link{parser_parse}}, take its
#' \code{\link{tree_root_node}}, and walk that with the \code{node_*}
#' functions, a \code{\link{tree_walk}} cursor, or a \code{\link{query}}.
#'
#' @useDynLib bonsaisitter, .registration = TRUE
#' @keywords internal
"_PACKAGE"
