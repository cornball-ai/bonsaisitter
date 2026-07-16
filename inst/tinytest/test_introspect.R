library(bonsaisitter)

if (!requireNamespace("treesitter.r", quietly = TRUE)) exit_file("treesitter.r not installed")

lang <- treesitter.r::language()

# -- text_parse convenience --
tree <- text_parse("f <- function(x) x + 1\n", lang)
expect_true(is_tree(tree))
root <- tree_root_node(tree)

# -- Node state: valid code has no error --
expect_false(node_has_error(root))
expect_false(node_is_error(root))
expect_false(node_is_missing(root))

# -- Broken code trips node_has_error --
broke <- tree_root_node(text_parse("f <- function(\n", lang))
expect_true(node_has_error(broke))

# -- Descendant count, grammar type, node language --
expect_true(node_descendant_count(root) > 5)
expect_equal(node_grammar_type(root), "program")
expect_true(is_language(node_language(root)))
expect_equal(language_name(node_language(root)), "r")

# -- Language symbol table round-trips --
expect_true(language_symbol_count(lang) > 0)
sym <- language_symbol_for_name(lang, "identifier", named = TRUE)
expect_true(sym > 0)
expect_equal(language_symbol_name(lang, sym), "identifier")

# -- Language field table round-trips --
expect_true(language_field_count(lang) > 0)
fid <- language_field_id_for_name(lang, "parameters")
expect_true(fid > 0)
expect_equal(language_field_name_for_id(lang, fid), "parameters")
