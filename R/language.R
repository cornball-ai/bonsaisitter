##' Return the tree-sitter R language grammar
##'
##' Returns an external pointer to the bundled R language grammar
##' for use with \code{\link{ts_parser_set_language}}.
##'
##' @return An external pointer of class \code{"ts_language"}.
##' @export
ts_language_r <- function() {
    .Call(c_ts_language_r)
}

##' Return the tree-sitter Python language grammar
##'
##' Returns an external pointer to the bundled Python language grammar
##' for use with \code{\link{ts_parser_set_language}}.
##'
##' @return An external pointer of class \code{"ts_language"}.
##' @export
ts_language_python <- function() {
    .Call(c_ts_language_python)
}
