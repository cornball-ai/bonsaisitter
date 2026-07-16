#' Parse text in one step
#'
#' `text_parse()` is a convenience wrapper that builds a parser for `language`
#' and parses `x` with it, returning the tree directly.
#'
#' @param x A single string to parse.
#' @param language A `tree_sitter_language`.
#' @return A `tree_sitter_tree`.
#' @export
text_parse <- function(x, language) {
    check_string(x)
    check_language(language)
    parser_parse(parser(language), x)
}
