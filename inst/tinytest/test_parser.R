library(treesitR)

# -- Parser creation --
parser <- ts_parser_new()
expect_true(inherits(parser, "ts_parser"))

# -- Language --
lang <- ts_language_r()
expect_true(inherits(lang, "ts_language"))
expect_true(ts_parser_set_language(parser, lang))

# -- Parse simple expression --
tree <- ts_parse(parser, "x <- 1 + 2\n")
expect_true(inherits(tree, "ts_tree"))
expect_equal(ts_tree_text(tree), "x <- 1 + 2\n")

# -- Root node --
root <- ts_tree_root_node(tree)
expect_true(inherits(root, "ts_node"))
expect_equal(ts_node_type(root), "program")
expect_true(ts_node_is_named(root))
expect_equal(ts_node_child_count(root), 1L)

# -- Parse function definition --
tree2 <- ts_parse(parser, "f <- function(x) x + 1\n")
root2 <- ts_tree_root_node(tree2)
expect_equal(ts_node_type(root2), "program")
sexpr <- ts_node_sexpr(root2)
expect_true(grepl("function_definition", sexpr))

# -- Parse empty string --
tree3 <- ts_parse(parser, "")
root3 <- ts_tree_root_node(tree3)
expect_equal(ts_node_type(root3), "program")
expect_equal(ts_node_child_count(root3), 0L)

# -- Parse multiple expressions --
tree4 <- ts_parse(parser, "x <- 1\ny <- 2\n")
root4 <- ts_tree_root_node(tree4)
expect_equal(ts_node_child_count(root4), 2L)

# -- Print methods --
expect_silent(print(tree))
expect_silent(print(root))
