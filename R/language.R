# tree_sitter_language = list(pointer, abi, name). Matches treesitter so the
# same objects flow between the two packages and the posit grammar packages.

new_language <- function(pointer, abi, name) {
    out <- list(pointer = pointer, abi = abi, name = name)
    class(out) <- "tree_sitter_language"
    out
}

language_from_pointer <- function(pointer, name) {
    new_language(pointer, .Call(c_ts_language_version, pointer), name)
}

#' Bundled tree-sitter grammars
#'
#' @description
#' `language_r()`, `language_python()`, and `language_cpp()` return the bundled
#' grammar as a `tree_sitter_language` object, for use with [parser()].
#'
#' @return A `tree_sitter_language`.
#' @name languages
#' @export
language_r <- function() {
    language_from_pointer(.Call(c_ts_language_r), "r")
}

#' @rdname languages
#' @export
language_python <- function() {
    language_from_pointer(.Call(c_ts_language_python), "python")
}

#' @rdname languages
#' @export
language_cpp <- function() {
    language_from_pointer(.Call(c_ts_language_cpp), "cpp")
}

#' The name of a language
#'
#' @param x A `tree_sitter_language`.
#' @return A single string.
#' @export
language_name <- function(x) {
    check_language(x)
    .subset2(x, "name")
}

#' Is `x` a language?
#'
#' @param x An object.
#' @return `TRUE` or `FALSE`.
#' @export
is_language <- function(x) {
    inherits(x, "tree_sitter_language")
}

#' @export
print.tree_sitter_language <- function(x, ...) {
    cat_line("<tree_sitter_language>")
    cat_line(sprintf("Name: %s", .subset2(x, "name")))
    cat_line(sprintf("ABI: %d", as.integer(.subset2(x, "abi"))))
    invisible(x)
}

language_pointer <- function(x) {
    .subset2(x, "pointer")
}

check_language <- function(x, arg = "language") {
    check_inherits(x, "tree_sitter_language", arg)
}
