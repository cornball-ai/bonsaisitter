library(bonsaisitter)

# -- Language + parser --
lang <- language_r()
expect_true(inherits(lang, "tree_sitter_language"))
expect_equal(lang$abi, 14L)

parser <- parser(lang)
expect_true(inherits(parser, "tree_sitter_parser"))

# -- Parse simple expression --
tree <- parser_parse(parser, "x <- 1 + 2\n")
expect_true(inherits(tree, "tree_sitter_tree"))
expect_equal(tree_text(tree), "x <- 1 + 2\n")

# -- Root node --
root <- tree_root_node(tree)
expect_true(inherits(root, "tree_sitter_node"))
expect_equal(node_type(root), "program")
expect_true(node_is_named(root))
expect_equal(node_child_count(root), 1)

# -- Parse function definition --
tree2 <- parser_parse(parser, "f <- function(x) x + 1\n")
root2 <- tree_root_node(tree2)
expect_equal(node_type(root2), "program")
sexpr <- node_raw_s_expression(root2)
expect_true(grepl("function_definition", sexpr))

# -- Parse empty string --
tree3 <- parser_parse(parser, "")
root3 <- tree_root_node(tree3)
expect_equal(node_type(root3), "program")
expect_equal(node_child_count(root3), 0)

# -- Parse multiple expressions --
tree4 <- parser_parse(parser, "x <- 1\ny <- 2\n")
root4 <- tree_root_node(tree4)
expect_equal(node_child_count(root4), 2)

# -- Predicates --
expect_true(is_parser(parser))
expect_true(is_tree(tree))
expect_true(is_node(root))
expect_true(is_language(lang))

# -- Print methods --
expect_silent(print(tree))
expect_silent(print(root))
