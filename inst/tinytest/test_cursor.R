library(bonsaisitter)

if (!requireNamespace("treesitter.r", quietly = TRUE)) exit_file("treesitter.r not installed")

p <- parser(treesitter.r::language())
tree <- parser_parse(p, "x <- 1\ny <- 2\n")

# -- Creation --
cur <- tree_walk(tree)
expect_true(is_tree_cursor(cur))
expect_equal(cur$depth(), 0)
expect_equal(node_type(cur$node()), "program")

# -- First child --
expect_true(cur$goto_first_child())
expect_equal(cur$depth(), 1)
expect_equal(node_type(cur$node()), "binary_operator")

# -- Next sibling --
expect_true(cur$goto_next_sibling())
expect_equal(node_type(cur$node()), "binary_operator")
expect_equal(node_text(cur$node()), "y <- 2")

# -- No more siblings --
expect_false(cur$goto_next_sibling())

# -- Parent --
expect_true(cur$goto_parent())
expect_equal(cur$depth(), 0)
expect_equal(node_type(cur$node()), "program")

# -- Cannot go above root --
expect_false(cur$goto_parent())

# -- node_walk drills in --
cur2 <- node_walk(tree_root_node(tree))
cur2$goto_first_child()   # binary_operator
cur2$goto_first_child()   # identifier "x"
expect_equal(node_type(cur2$node()), "identifier")
expect_equal(cur2$depth(), 2)

# -- Field name is a string (or NA) --
tree3 <- parser_parse(p, "f <- function(x) x\n")
cur3 <- tree_walk(tree3)
cur3$goto_first_child()
expect_true(is.character(cur3$field_name()))

# -- Print --
expect_silent(print(cur))
