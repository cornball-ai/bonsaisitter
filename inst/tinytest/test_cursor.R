library(treesitR)

parser <- ts_parser_new()
ts_parser_set_language(parser, ts_language_r())
tree <- ts_parse(parser, "x <- 1\ny <- 2\n")
root <- ts_tree_root_node(tree)

# -- Cursor creation --
cursor <- ts_cursor_new(root)
expect_true(inherits(cursor, "ts_cursor"))
expect_equal(ts_cursor_depth(cursor), 0L)

# -- Current node --
node <- ts_cursor_node(cursor)
expect_equal(ts_node_type(node), "program")

# -- Navigate to first child --
expect_true(ts_cursor_goto_first_child(cursor))
expect_equal(ts_cursor_depth(cursor), 1L)
node <- ts_cursor_node(cursor)
expect_equal(ts_node_type(node), "binary_operator")

# -- Navigate to next sibling --
expect_true(ts_cursor_goto_next_sibling(cursor))
node <- ts_cursor_node(cursor)
expect_equal(ts_node_type(node), "binary_operator")
expect_equal(ts_node_text(node), "y <- 2")

# -- No more siblings --
expect_false(ts_cursor_goto_next_sibling(cursor))

# -- Navigate to parent --
expect_true(ts_cursor_goto_parent(cursor))
expect_equal(ts_cursor_depth(cursor), 0L)
node <- ts_cursor_node(cursor)
expect_equal(ts_node_type(node), "program")

# -- Cannot go above root --
expect_false(ts_cursor_goto_parent(cursor))

# -- Deeper traversal --
tree2 <- ts_parse(parser, "f <- function(x) x + 1\n")
root2 <- ts_tree_root_node(tree2)
cursor2 <- ts_cursor_new(root2)

ts_cursor_goto_first_child(cursor2)  # binary_operator
ts_cursor_goto_first_child(cursor2)  # identifier "f"
expect_equal(ts_node_type(ts_cursor_node(cursor2)), "identifier")
expect_equal(ts_cursor_depth(cursor2), 2L)

# -- Field name --
# Navigate to function_definition's parameters
tree3 <- ts_parse(parser, "function(x) x\n")
root3 <- ts_tree_root_node(tree3)
cursor3 <- ts_cursor_new(root3)
ts_cursor_goto_first_child(cursor3)  # function_definition
ts_cursor_goto_first_child(cursor3)  # "function" keyword
# Move through children to find one with a field name
field <- ts_cursor_field_name(cursor3)
# field may be NA for anonymous tokens
expect_true(is.character(field))

# -- Print method --
expect_silent(print(cursor))
