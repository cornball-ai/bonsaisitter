#' Create a new tree-sitter parser
#'
#' @return An external pointer of class \code{"ts_parser"}.
#' @export
ts_parser_new <- function() {
    .Call(c_ts_parser_new)
}

#' Set the language for a parser
#'
#' @param parser A parser created by \code{\link{ts_parser_new}}.
#' @param language A language object, e.g. from \code{\link{ts_language_r}}.
#' @return \code{TRUE} on success, \code{FALSE} on ABI version mismatch.
#' @export
ts_parser_set_language <- function(parser, language) {
    .Call(c_ts_parser_set_language, parser, language)
}

#' Parse source code into a syntax tree
#'
#' @param parser A parser with a language set.
#' @param source A single character string of source code.
#' @param old_tree Optional previous tree for incremental parsing.
#' @return A \code{ts_tree} object (list with \code{$ptr} and \code{$source}).
#' @export
ts_parse <- function(parser, source, old_tree = NULL) {
    stopifnot(is.character(source), length(source) == 1L)
    tree <- .Call(c_ts_parse, parser, source, old_tree)
    .Call(c_ts_tree_register_finalizer, tree[["ptr"]])
    tree
}
