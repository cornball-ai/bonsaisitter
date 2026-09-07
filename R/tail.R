# Remaining treesitter API surface. Extends node.R, introspect.R, query.R, and
# tree.R; kept together as the completion pass.

# ---- Node: symbols and parse states ----

#' Node symbols and parse states
#'
#' @param x A \code{tree_sitter_node}.
#' @return A single double.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
#'   node_symbol(node)
#'   language_symbol_name(node_language(node), node_symbol(node))
#'   node_parse_state(node)
#' }
#' @rdname node-symbols
#' @export
node_symbol <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_symbol, node_raw(x)))
}

#' @rdname node-symbols
#' @export
node_grammar_symbol <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_grammar_symbol, node_raw(x)))
}

#' @rdname node-symbols
#' @export
node_parse_state <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_parse_state, node_raw(x)))
}

#' @rdname node-symbols
#' @export
node_next_parse_state <- function(x) {
    check_node(x)
    as.double(.Call(c_ts_node_next_parse_state, node_raw(x)))
}

# ---- Node: field-by-id and field names ----

#' A child by field id
#'
#' @param x A \code{tree_sitter_node}.
#' @param id A field id (see \code{\link{language_field_id_for_name}}).
#' @return A \code{tree_sitter_node}, or \code{NULL}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   lang <- treesitter.r::language()
#'   expr <- node_child(tree_root_node(text_parse("x <- 1", lang)), 1)
#'   id <- language_field_id_for_name(lang, "lhs")
#'   node_text(node_child_by_field_id(expr, id))
#' }
#' @export
node_child_by_field_id <- function(x, id) {
    check_node(x)
    wrap_node(.Call(c_ts_node_child_by_field_id, node_raw(x), as.integer(id)),
              node_tree(x))
}

#' Field name for a child (1-indexed)
#'
#' @param x A \code{tree_sitter_node}.
#' @param i A 1-indexed child position.
#' @return A single string, or \code{NA} if the child has no field.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   expr <- node_child(tree_root_node(tree), 1)
#'   c(node_field_name_for_child(expr, 1), node_field_name_for_named_child(expr, 2))
#' }
#' @rdname node-field-name
#' @export
node_field_name_for_child <- function(x, i) {
    check_node(x)
    .Call(c_ts_node_field_name_for_child, node_raw(x), as.integer(i) - 1L)
}

#' @rdname node-field-name
#' @export
node_field_name_for_named_child <- function(x, i) {
    check_node(x)
    .Call(c_ts_node_field_name_for_named_child, node_raw(x), as.integer(i) - 1L)
}

# ---- Node: byte / point lookups ----

#' Locate nodes by byte or point
#'
#' @param x A \code{tree_sitter_node}.
#' @param byte,start,end 0-indexed byte offsets.
#' @param start_point,end_point \code{tree_sitter_point} objects.
#' @return A \code{tree_sitter_node}, or \code{NULL}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   root <- tree_root_node(text_parse("x <- 1\ny <- 2", treesitter.r::language()))
#'   node_text(node_first_named_child_for_byte(root, 7))
#'   node_text(node_descendant_for_byte_range(root, 7, 7))
#'   node_text(node_descendant_for_point_range(root, point(1, 0), point(1, 0)))
#' }
#' @rdname node-locate
#' @export
node_first_child_for_byte <- function(x, byte) {
    check_node(x)
    wrap_node(.Call(c_ts_node_first_child_for_byte, node_raw(x),
                    as.integer(byte)),
              node_tree(x))
}

#' @rdname node-locate
#' @export
node_first_named_child_for_byte <- function(x, byte) {
    check_node(x)
    wrap_node(.Call(c_ts_node_first_named_child_for_byte, node_raw(x),
                    as.integer(byte)),
              node_tree(x))
}

#' @rdname node-locate
#' @export
node_descendant_for_byte_range <- function(x, start, end) {
    check_node(x)
    wrap_node(.Call(c_ts_node_descendant_for_byte_range, node_raw(x),
                    as.integer(start), as.integer(end)), node_tree(x))
}

#' @rdname node-locate
#' @export
node_named_descendant_for_byte_range <- function(x, start, end) {
    check_node(x)
    wrap_node(.Call(c_ts_node_named_descendant_for_byte_range, node_raw(x),
                    as.integer(start), as.integer(end)), node_tree(x))
}

#' @rdname node-locate
#' @export
node_descendant_for_point_range <- function(x, start_point, end_point) {
    check_node(x)
    check_point(start_point, arg = "start_point")
    check_point(end_point, arg = "end_point")
    wrap_node(.Call(c_ts_node_descendant_for_point_range, node_raw(x),
                    as.integer(point_row0(start_point)),
                    as.integer(point_column0(start_point)),
                    as.integer(point_row0(end_point)),
                    as.integer(point_column0(end_point))),
              node_tree(x))
}

#' @rdname node-locate
#' @export
node_named_descendant_for_point_range <- function(x, start_point, end_point) {
    check_node(x)
    check_point(start_point, arg = "start_point")
    check_point(end_point, arg = "end_point")
    wrap_node(.Call(c_ts_node_named_descendant_for_point_range, node_raw(x),
                    as.integer(point_row0(start_point)),
                    as.integer(point_column0(start_point)),
                    as.integer(point_row0(end_point)),
                    as.integer(point_column0(end_point))),
              node_tree(x))
}

# ---- Language: states ----

#' Language parse states
#'
#' @param x A \code{tree_sitter_language}.
#' @param state A parse state id.
#' @param symbol A symbol id.
#' @return A single double.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   lang <- treesitter.r::language()
#'   language_state_count(lang)
#'   node <- tree_root_node(text_parse("x <- 1", lang))
#'   language_next_state(lang, node_parse_state(node), node_grammar_symbol(node))
#' }
#' @rdname language-states
#' @export
language_state_count <- function(x) {
    check_language(x)
    as.double(.Call(c_ts_language_state_count, language_pointer(x)))
}

#' @rdname language-states
#' @export
language_next_state <- function(x, state, symbol) {
    check_language(x)
    as.double(.Call(c_ts_language_next_state, language_pointer(x),
                    as.integer(state), as.integer(symbol)))
}

# ---- Query: matches and byte-for-pattern ----

#' Query byte ranges per pattern (1-indexed pattern)
#'
#' @param x A \code{tree_sitter_query}.
#' @param i A 1-indexed pattern position.
#' @return A single double (0-indexed byte).
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   q <- query(treesitter.r::language(), "(call) @call (identifier) @id")
#'   c(query_start_byte_for_pattern(q, 2), query_end_byte_for_pattern(q, 2))
#' }
#' @rdname query-bytes
#' @export
query_start_byte_for_pattern <- function(x, i) {
    check_query(x)
    as.double(.Call(c_ts_query_start_byte_for_pattern, query_pointer0(x),
                    as.integer(i) - 1L))
}

#' @rdname query-bytes
#' @export
query_end_byte_for_pattern <- function(x, i) {
    check_query(x)
    as.double(.Call(c_ts_query_end_byte_for_pattern, query_pointer0(x),
                    as.integer(i) - 1L))
}

#' Run a query and collect its matches
#'
#' Unlike treesitter, which nests matches by pattern, this returns a flat list
#' of matches. Each match is \code{list(pattern, name, node)}: the 0-indexed pattern,
#' the capture names, and the captured \code{tree_sitter_node}s.
#'
#' @param x A \code{tree_sitter_query}.
#' @param node A \code{tree_sitter_node} to search within.
#' @return A list of matches.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   lang <- treesitter.r::language()
#'   node <- tree_root_node(text_parse("f(1); g(2)", lang))
#'   q <- query(lang, "(call function: (identifier) @fn)")
#'   matches <- query_matches(q, node)
#'   vapply(matches, function(m) node_text(m$node[[1]]), character(1))
#' }
#' @export
query_matches <- function(x, node) {
    check_query(x)
    check_node(node)
    tree <- node_tree(node)
    ms <- .Call(c_ts_query_matches, query_pointer0(x), node_raw(node))
    lapply(ms, function(m) {
        list(pattern = m[["pattern"]], name = m[["name"]],
             node = lapply(m[["node"]], new_node, tree = tree))
    })
}

# ---- Tree: included ranges and offset root ----

#' The tree's included ranges
#'
#' @param x A \code{tree_sitter_tree}.
#' @return A list of \code{tree_sitter_range} objects.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   tree_included_ranges(tree)
#' }
#' @export
tree_included_ranges <- function(x) {
    check_tree(x)
    info <- .Call(c_ts_tree_included_ranges, tree_pointer(x))
    n <- length(info[[1L]])
    out <- vector("list", n)
    for (i in seq_len(n)) {
        out[[i]] <- new_range(info[[1L]][i],
                              new_point(info[[2L]][i], info[[3L]][i]),
                              info[[4L]][i],
                              new_point(info[[5L]][i], info[[6L]][i]))
    }
    out
}

#' An offset root node
#'
#' Returns the root node shifted forward by \code{byte} and \code{point}, so positions
#' read in the coordinate space of a larger document.
#'
#' @param x A \code{tree_sitter_tree}.
#' @param byte A 0-indexed byte offset.
#' @param point A \code{tree_sitter_point} offset.
#' @return A \code{tree_sitter_node}.
#' @examples
#' if (requireNamespace("treesitter.r", quietly = TRUE)) {
#'   tree <- text_parse("x <- 1", treesitter.r::language())
#'   node <- tree_root_node_with_offset(tree, 10, point(2, 0))
#'   node_start_point(node)
#' }
#' @export
tree_root_node_with_offset <- function(x, byte, point) {
    check_tree(x)
    check_point(point)
    byte <- as.double(byte)
    check_number_whole(byte, min = 0, arg = "byte")
    padded <- paste0(strrep(" ", byte), tree_text0(x))
    x2 <- new_tree(tree_pointer(x), padded, tree_language0(x))
    raw <- .Call(c_ts_tree_root_node_with_offset, tree_pointer(x),
                 as.integer(byte), as.integer(point_row0(point)),
                 as.integer(point_column0(point)))
    new_node(raw, x2)
}
