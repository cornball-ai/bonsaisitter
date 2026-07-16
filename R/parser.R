# tree_sitter_parser = list(language, pointer).

new_parser <- function(language) {
    pointer <- .Call(c_ts_parser_new)
    ok <- .Call(c_ts_parser_set_language, pointer, language_pointer(language))
    if (!isTRUE(ok)) {
        stop(
            "Failed to set the language on the parser (incompatible ABI version?).",
            call. = FALSE
        )
    }
    out <- list(language = language, pointer = pointer)
    class(out) <- "tree_sitter_parser"
    out
}

#' Create a parser
#'
#' `parser()` constructs a parser from a `tree_sitter_language`. Use
#' [parser_parse()] to parse text with it.
#'
#' @param language A `tree_sitter_language`, e.g. from [language_r()] or a
#'   grammar package like `treesitter.r::language()`.
#' @return A `tree_sitter_parser`.
#' @export
parser <- function(language) {
    check_language(language)
    new_parser(language)
}

#' Set a parser's language
#'
#' @param x A `tree_sitter_parser`.
#' @param language A `tree_sitter_language`.
#' @return A new `tree_sitter_parser`.
#' @export
parser_set_language <- function(x, language) {
    check_parser(x)
    check_language(language)
    new_parser(language)
}

#' Parse text into a syntax tree
#'
#' @param x A `tree_sitter_parser`.
#' @param text A single string to parse.
#' @param ... Unused.
#' @return A `tree_sitter_tree`.
#' @export
parser_parse <- function(x, text, ...) {
    check_parser(x)
    check_string(text)
    pointer <- .Call(c_ts_parse, parser_pointer0(x), text, NULL)
    .Call(c_ts_tree_register_finalizer, pointer)
    new_tree(pointer, text, parser_language0(x))
}

#' Is `x` a parser?
#'
#' @param x An object.
#' @return `TRUE` or `FALSE`.
#' @export
is_parser <- function(x) {
    inherits(x, "tree_sitter_parser")
}

#' @export
print.tree_sitter_parser <- function(x, ...) {
    cat_line("<tree_sitter_parser>")
    cat_line(sprintf("Language: %s", language_name(parser_language0(x))))
    invisible(x)
}

parser_language0 <- function(x) {
    .subset2(x, "language")
}

parser_pointer0 <- function(x) {
    .subset2(x, "pointer")
}

check_parser <- function(x, arg = "x") {
    check_inherits(x, "tree_sitter_parser", arg)
}
