library(bonsaisitter)

parser <- parser(language_r())
tree <- parser_parse(parser, "f <- function(x, y = 1) {\n  x + y\n}\n")
root <- tree_root_node(tree)

# -- Node type and text --
assign <- node_child(root, 1)
expect_equal(node_type(assign), "binary_operator")
expect_true(nchar(node_text(assign)) > 0)

# -- Named vs anonymous --
expect_true(node_is_named(assign))
# The <- operator token is anonymous (second child, 1-indexed)
arrow <- node_child(assign, 2)
expect_equal(node_text(arrow), "<-")
expect_false(node_is_named(arrow))

# -- Points and bytes --
sp <- node_start_point(assign)
expect_true(is_point(sp))
expect_equal(point_row(sp), 0)
expect_equal(point_column(sp), 0)
ep <- node_end_point(assign)
expect_true(point_row(ep) >= 0)

sb <- node_start_byte(assign)
eb <- node_end_byte(assign)
expect_true(eb > sb)

# -- Range --
rng <- node_range(assign)
expect_true(is_range(rng))
expect_equal(range_start_byte(rng), sb)
expect_equal(range_end_byte(rng), eb)

# -- Children --
expect_true(node_child_count(assign) >= 3)
expect_true(node_named_child_count(assign) >= 2)

kids <- node_children(assign)
expect_true(length(kids) >= 3)

kids_named <- node_named_children(assign)
expect_true(length(kids_named) >= 2)

# -- Named child navigation --
lhs <- node_named_child(assign, 1)
expect_equal(node_type(lhs), "identifier")
expect_equal(node_text(lhs), "f")

rhs <- node_named_child(assign, 2)
expect_equal(node_type(rhs), "function_definition")

# -- Parent --
parent <- node_parent(lhs)
expect_equal(node_type(parent), "binary_operator")

# -- Siblings --
first <- node_child(assign, 1)
second <- node_next_sibling(first)
expect_false(is.null(second))
back <- node_previous_sibling(second)
expect_equal(node_text(back), node_text(first))

# -- Named siblings --
first_named <- node_named_child(assign, 1)
next_named <- node_next_named_sibling(first_named)
expect_false(is.null(next_named))
expect_equal(node_type(next_named), "function_definition")

# -- Child by field --
funcdef <- node_named_child(assign, 2)
params <- node_child_by_field_name(funcdef, "parameters")
expect_false(is.null(params))
expect_equal(node_type(params), "parameters")

body_node <- node_child_by_field_name(funcdef, "body")
expect_false(is.null(body_node))

# -- Missing field returns NULL --
no_field <- node_child_by_field_name(root, "nonexistent")
expect_true(is.null(no_field))

# -- S-expression --
sexpr <- node_raw_s_expression(root)
expect_true(is.character(sexpr))
expect_true(grepl("program", sexpr))

# -- as.data.frame (base data frame, not a tibble) --
df <- as.data.frame(root)
expect_true(is.data.frame(df))
expect_false(inherits(df, "tbl_df"))
expect_true(nrow(df) > 1)
expect_true("type" %in% names(df))
expect_true("named" %in% names(df))
expect_true("text" %in% names(df))
expect_true("start_row" %in% names(df))
expect_true("start_byte" %in% names(df))
expect_equal(df$type[1], "program")
