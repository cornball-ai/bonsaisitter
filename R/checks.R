# Base-R validation and message helpers. No cli / rlang.

cat_line <- function(...) {
    cat(..., "\n", sep = "")
}

check_inherits <- function(x, cls, arg) {
    if (inherits(x, cls)) {
        return(invisible(NULL))
    }
    stop(sprintf("`%s` must be a <%s>.", arg, cls), call. = FALSE)
}

check_string <- function(x, arg = "text") {
    if (is.character(x) && length(x) == 1L && !is.na(x)) {
        return(invisible(NULL))
    }
    stop(sprintf("`%s` must be a single string.", arg), call. = FALSE)
}

check_number_whole <- function(x, min = NULL, arg = "x") {
    ok <- is.numeric(x) && length(x) == 1L && !is.na(x) && x == trunc(x)
    if (!ok) {
        stop(sprintf("`%s` must be a single whole number.", arg), call. = FALSE)
    }
    if (!is.null(min) && x < min) {
        stop(sprintf("`%s` must be greater than or equal to %s.", arg, min), call. = FALSE)
    }
    invisible(NULL)
}

`%||%` <- function(x, y) {
    if (is.null(x)) y else x
}
