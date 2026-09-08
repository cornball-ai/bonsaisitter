# tree_sitter_point = list(row, column). 0-indexed, matching treesitter.

new_point <- function(row, column) {
    out <- list(row = row, column = column)
    class(out) <- "tree_sitter_point"
    out
}

#' Points
#'
#' @description
#' - \code{point()} creates a tree-sitter point. Points are 0-indexed.
#' - \code{point_row()} and \code{point_column()} access the row and column.
#' - \code{is_point()} tests for a point.
#'
#' @param row,column A 0-indexed row / column (single whole number).
#' @param x A \code{tree_sitter_point}.
#' @return \code{point()} a point; the accessors a double; \code{is_point()} a logical.
#' @examples
#' p <- point(2, 4)
#' p
#' point_row(p)
#' point_column(p)
#' is_point(p)
#' @rdname points
#' @export
point <- function(row, column) {
    row <- as.double(row)
    column <- as.double(column)
    check_number_whole(row, min = 0, arg = "row")
    check_number_whole(column, min = 0, arg = "column")
    new_point(row, column)
}

#' @rdname points
#' @export
point_row <- function(x) {
    check_point(x)
    .subset2(x, "row")
}

#' @rdname points
#' @export
point_column <- function(x) {
    check_point(x)
    .subset2(x, "column")
}

#' @rdname points
#' @export
is_point <- function(x) {
    inherits(x, "tree_sitter_point")
}

#' @export
print.tree_sitter_point <- function(x, ...) {
    cat_line("<tree_sitter_point>")
    cat_line(sprintf("Row: %g", .subset2(x, "row")))
    cat_line(sprintf("Column: %g", .subset2(x, "column")))
    invisible(x)
}

point_row0 <- function(x) {
    .subset2(x, "row")
}

point_column0 <- function(x) {
    .subset2(x, "column")
}

check_point <- function(x, arg = "x") {
    check_inherits(x, "tree_sitter_point", arg)
}
