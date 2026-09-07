# tree_sitter_language objects come from grammar packages (treesitter.r,
# treesitter.python, treesitter.cpp, treesitter.c, ...). bonsaisitter is the
# runtime: it consumes languages, it does not bundle or construct grammars.

#' The name of a language
#'
#' @param x A \code{tree_sitter_language}.
#' @return A single string.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   language_name(treesitter.r::language())
#' }
#' @export
language_name <- function(x) {
    check_language(x)
    .subset2(x, "name")
}

#' Is \code{x} a language?
#'
#' @param x An object.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   is_language(treesitter.r::language())
#' }
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
