# tree_sitter_parser = list(language, timeout, included_ranges, pointer).
# timeout is in microseconds (0 = no limit).

transpose_ranges <- function(ranges) {
    list(
         sb = vapply(ranges, range_start_byte0, double(1)),
         sr = vapply(ranges, function(r) point_row0(range_start_point0(r)),
                     double(1)),
         sc = vapply(ranges, function(r) point_column0(range_start_point0(r)), double(1)),
         eb = vapply(ranges, range_end_byte0, double(1)),
         er = vapply(ranges, function(r) point_row0(range_end_point0(r)), double(1)),
         ec = vapply(ranges, function(r) point_column0(range_end_point0(r)), double(1))
    )
}

new_parser <- function(language, timeout = 0, included_ranges = list()) {
    pointer <- .Call(c_ts_parser_new)
    ok <- .Call(c_ts_parser_set_language, pointer, language_pointer(language))
    if (!isTRUE(ok)) {
        stop(
             "Failed to set the language on the parser (incompatible ABI version?).",
             call. = FALSE
        )
    }
    if (length(included_ranges) > 0) {
        tr <- transpose_ranges(included_ranges)
        .Call(c_ts_parser_set_included_ranges, pointer, tr$sb, tr$sr,
              tr$sc, tr$eb, tr$er, tr$ec)
    }
    out <- list(
                language = language,
                timeout = timeout,
                included_ranges = included_ranges,
                pointer = pointer
    )
    class(out) <- "tree_sitter_parser"
    out
}

#' Create a parser
#'
#' \code{parser()} constructs a parser from a \code{tree_sitter_language}. Use
#' \code{\link{parser_parse}} to parse text with it.
#'
#' @param language A \code{tree_sitter_language}, e.g. from a grammar package like
#'   \code{treesitter.r::language()}.
#' @return A \code{tree_sitter_parser}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   p <- parser(treesitter.r::language())
#'   tree <- parser_parse(p, "x <- f(1, 2)")
#'   node_type(tree_root_node(tree))
#' }
#' @export
parser <- function(language) {
    check_language(language)
    new_parser(language)
}

#' Adjust a parser
#'
#' @description
#' Each returns a new parser with one setting changed.
#' - \code{parser_set_language()} sets the language.
#' - \code{parser_set_timeout()} sets a parse timeout in microseconds (0 clears it).
#' - \code{parser_set_included_ranges()} restricts parsing to a list of \code{\link{range}}s
#'   (an empty list clears the restriction).
#'
#' @param x A \code{tree_sitter_parser}.
#' @param language A \code{tree_sitter_language}.
#' @param timeout A single whole number of microseconds.
#' @param included_ranges A list of \code{tree_sitter_range} objects.
#' @return A new \code{tree_sitter_parser}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   lang <- treesitter.r::language()
#'   p <- parser_set_timeout(parser(lang), 1e6)
#'   p <- parser_set_language(p, lang)
#'   first_line <- range(0, point(0, 0), 6, point(0, 6))
#'   p <- parser_set_included_ranges(p, list(first_line))
#'   node_text(tree_root_node(parser_parse(p, "x <- 1\ny <- 2")))
#' }
#' @rdname parser-adjust
#' @export
parser_set_language <- function(x, language) {
    check_parser(x)
    check_language(language)
    new_parser(language, x$timeout, x$included_ranges)
}

#' @rdname parser-adjust
#' @export
parser_set_timeout <- function(x, timeout) {
    check_parser(x)
    timeout <- as.double(timeout)
    check_number_whole(timeout, min = 0, arg = "timeout")
    new_parser(x$language, timeout, x$included_ranges)
}

#' @rdname parser-adjust
#' @export
parser_set_included_ranges <- function(x, included_ranges) {
    check_parser(x)
    if (!is.list(included_ranges) ||
        !all(vapply(included_ranges, is_range, logical(1)))) {
        stop("`included_ranges` must be a list of <tree_sitter_range>.",
             call. = FALSE)
    }
    new_parser(x$language, x$timeout, included_ranges)
}

#' Parse or reparse text
#'
#' @description
#' - \code{parser_parse()} parses \code{text} and returns a \code{tree_sitter_tree}.
#' - \code{parser_reparse()} performs an incremental reparse of a slightly edited
#'   \code{text}, reusing the old \code{tree}. All bytes and points are 0-indexed.
#'
#' @param x A \code{tree_sitter_parser}.
#' @param text A single string to parse.
#' @param tree The original \code{tree_sitter_tree} from \code{parser_parse()}.
#' @param start_byte,old_end_byte,new_end_byte Edit byte offsets.
#' @param start_point,old_end_point,new_end_point Edit \code{tree_sitter_point}s.
#' @param ... Unused.
#' @return A \code{tree_sitter_tree}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   p <- parser(treesitter.r::language())
#'   tree <- parser_parse(p, "x <- 1")
#'   # Replace the "1" at byte 5 with "42", then reparse incrementally.
#'   tree2 <- parser_reparse(p, "x <- 42", tree, 5, point(0, 5), 6, point(0, 6),
#'                           7, point(0, 7))
#'   node_text(tree_root_node(tree2))
#' }
#' @rdname parser-parse
#' @export
parser_parse <- function(x, text, ...) {
    check_parser(x)
    check_string(text)
    pointer <- .Call(c_ts_parse, parser_pointer0(x), text, NULL,
                     as.double(x$timeout))
    .Call(c_ts_tree_register_finalizer, pointer)
    new_tree(pointer, text, parser_language0(x))
}

#' @rdname parser-parse
#' @export
parser_reparse <- function(x, text, tree, start_byte, start_point,
                           old_end_byte, old_end_point, new_end_byte,
                           new_end_point) {
    check_parser(x)
    check_string(text)
    check_tree(tree)
    check_point(start_point, arg = "start_point")
    check_point(old_end_point, arg = "old_end_point")
    check_point(new_end_point, arg = "new_end_point")
    pointer <- .Call(c_ts_reparse, parser_pointer0(x), text,
                     tree_pointer(tree), as.double(x$timeout),
                     as.double(start_byte), as.double(old_end_byte),
                     as.double(new_end_byte),
                     as.integer(point_row0(start_point)),
                     as.integer(point_column0(start_point)),
                     as.integer(point_row0(old_end_point)),
                     as.integer(point_column0(old_end_point)),
                     as.integer(point_row0(new_end_point)),
                     as.integer(point_column0(new_end_point)))
    .Call(c_ts_tree_register_finalizer, pointer)
    new_tree(pointer, text, parser_language0(x))
}

#' Is \code{x} a parser?
#'
#' @param x An object.
#' @return \code{TRUE} or \code{FALSE}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   is_parser(parser(treesitter.r::language()))
#' }
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
