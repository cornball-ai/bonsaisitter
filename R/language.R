#' Return the tree-sitter R language grammar
#'
#' Returns an external pointer to the bundled R language grammar
#' for use with \code{\link{ts_parser_set_language}}.
#'
#' @return An external pointer of class \code{"ts_language"}.
#' @export
ts_language_r <- function() {
    .Call(c_ts_language_r)
}

#' Return the tree-sitter Python language grammar
#'
#' Returns an external pointer to the bundled Python language grammar
#' for use with \code{\link{ts_parser_set_language}}.
#'
#' @return An external pointer of class \code{"ts_language"}.
#' @export
ts_language_python <- function() {
    .Call(c_ts_language_python)
}

#' Return the tree-sitter C++ language grammar
#'
#' Returns an external pointer to the bundled C++ language grammar
#' (tree-sitter-cpp v0.23.4) for use with
#' \code{\link{ts_parser_set_language}}. Handy for parsing C/C++ headers,
#' for example to scaffold R bindings from a library's public API.
#'
#' @return An external pointer of class \code{"ts_language"}.
#' @export
ts_language_cpp <- function() {
    .Call(c_ts_language_cpp)
}
