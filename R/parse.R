#' Parse text in one step
#'
#' \code{text_parse()} is a convenience wrapper that builds a parser for \code{language}
#' and parses \code{x} with it, returning the tree directly.
#'
#' @param x A single string to parse.
#' @param language A \code{tree_sitter_language}.
#' @return A \code{tree_sitter_tree}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("f <- function(x) x + 1", treesitter.r::language())
#'   node_type(tree_root_node(tree))
#' }
#' @export
text_parse <- function(x, language) {
    check_string(x)
    check_language(language)
    parser_parse(parser(language), x)
}
