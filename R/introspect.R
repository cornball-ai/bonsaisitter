# Language introspection: symbol and field tables. Symbol and field ids are the
# raw tree-sitter ids (same numbering as treesitter).

#' Language symbols
#'
#' @description
#' - `language_symbol_count()` is the number of distinct node types.
#' - `language_symbol_name()` maps a symbol id to its name.
#' - `language_symbol_for_name()` maps a name to its symbol id.
#'
#' @param x A `tree_sitter_language`.
#' @param symbol A symbol id.
#' @param name A node type name.
#' @param named Whether to look up the named or anonymous variant.
#' @return Counts and ids as a double; names as a string.
#' @rdname language-symbols
#' @export
language_symbol_count <- function(x) {
    check_language(x)
    as.double(.Call(c_ts_language_symbol_count, language_pointer(x)))
}

#' @rdname language-symbols
#' @export
language_symbol_name <- function(x, symbol) {
    check_language(x)
    .Call(c_ts_language_symbol_name, language_pointer(x), as.integer(symbol))
}

#' @rdname language-symbols
#' @export
language_symbol_for_name <- function(x, name, named = TRUE) {
    check_language(x)
    as.double(.Call(c_ts_language_symbol_for_name, language_pointer(x),
                    as.character(name), as.logical(named)))
}

#' Language fields
#'
#' @description
#' - `language_field_count()` is the number of distinct fields.
#' - `language_field_name_for_id()` maps a field id to its name.
#' - `language_field_id_for_name()` maps a field name to its id.
#'
#' @param x A `tree_sitter_language`.
#' @param id A field id.
#' @param name A field name.
#' @return Counts and ids as a double; names as a string.
#' @rdname language-fields
#' @export
language_field_count <- function(x) {
    check_language(x)
    as.double(.Call(c_ts_language_field_count, language_pointer(x)))
}

#' @rdname language-fields
#' @export
language_field_name_for_id <- function(x, id) {
    check_language(x)
    .Call(c_ts_language_field_name_for_id, language_pointer(x), as.integer(id))
}

#' @rdname language-fields
#' @export
language_field_id_for_name <- function(x, name) {
    check_language(x)
    as.double(.Call(c_ts_language_field_id_for_name, language_pointer(x),
                    as.character(name)))
}
