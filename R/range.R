# tree_sitter_range = list(start_byte, start_point, end_byte, end_point).

new_range <- function(start_byte, start_point, end_byte, end_point) {
    out <- list(start_byte = start_byte, start_point = start_point,
                end_byte = end_byte, end_point = end_point)
    class(out) <- "tree_sitter_range"
    out
}

#' Ranges
#'
#' @description
#' - `range()` creates a tree-sitter range from a start/end byte and point.
#' - `range_start_byte()`, `range_start_point()`, `range_end_byte()`, and
#'   `range_end_point()` access the components.
#' - `is_range()` tests for a range.
#'
#' All bytes and points are 0-indexed.
#'
#' @param start_byte,end_byte Single whole numbers.
#' @param start_point,end_point `tree_sitter_point` objects.
#' @param x A `tree_sitter_range`.
#' @return `range()` a range; accessors their component; `is_range()` a logical.
#' @rdname ranges
#' @export
range <- function(start_byte, start_point, end_byte, end_point) {
    start_byte <- as.double(start_byte)
    end_byte <- as.double(end_byte)
    check_number_whole(start_byte, min = 0, arg = "start_byte")
    check_number_whole(end_byte, min = 0, arg = "end_byte")
    check_point(start_point, arg = "start_point")
    check_point(end_point, arg = "end_point")
    new_range(start_byte, start_point, end_byte, end_point)
}

#' @rdname ranges
#' @export
range_start_byte <- function(x) {
    check_range(x)
    .subset2(x, "start_byte")
}

#' @rdname ranges
#' @export
range_start_point <- function(x) {
    check_range(x)
    .subset2(x, "start_point")
}

#' @rdname ranges
#' @export
range_end_byte <- function(x) {
    check_range(x)
    .subset2(x, "end_byte")
}

#' @rdname ranges
#' @export
range_end_point <- function(x) {
    check_range(x)
    .subset2(x, "end_point")
}

#' @rdname ranges
#' @export
is_range <- function(x) {
    inherits(x, "tree_sitter_range")
}

#' @export
print.tree_sitter_range <- function(x, ...) {
    sp <- .subset2(x, "start_point")
    ep <- .subset2(x, "end_point")
    cat_line("<tree_sitter_range>")
    cat_line(sprintf("[%g, %g] - [%g, %g]", .subset2(sp, "row"),
                     .subset2(sp, "column"), .subset2(ep, "row"),
                     .subset2(ep, "column")))
    invisible(x)
}

range_start_byte0 <- function(x) {
    .subset2(x, "start_byte")
}

range_end_byte0 <- function(x) {
    .subset2(x, "end_byte")
}

range_start_point0 <- function(x) {
    .subset2(x, "start_point")
}

range_end_point0 <- function(x) {
    .subset2(x, "end_point")
}

check_range <- function(x, arg = "x") {
    check_inherits(x, "tree_sitter_range", arg)
}
