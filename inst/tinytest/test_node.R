library(treesitR)

parser <- ts_parser_new()
ts_parser_set_language(parser, ts_language_r())
tree <- ts_parse(parser, "f <- function(x, y = 1) {\n  x + y\n}\n")
root <- ts_tree_root_node(tree)

# -- Node type and text --
assign <- ts_node_child(root, 0L)
expect_equal(ts_node_type(assign), "binary_operator")
expect_true(nchar(ts_node_text(assign)) > 0)

# -- Named vs anonymous --
expect_true(ts_node_is_named(assign))
# The <- operator token is anonymous
arrow <- ts_node_child(assign, 1L)
expect_equal(ts_node_text(arrow), "<-")
expect_false(ts_node_is_named(arrow))

# -- Points and bytes --
sp <- ts_node_start_point(assign)
expect_equal(sp[["row"]], 0L)
expect_equal(sp[["column"]], 0L)
ep <- ts_node_end_point(assign)
expect_true(ep[["row"]] >= 0L)

sb <- ts_node_start_byte(assign)
eb <- ts_node_end_byte(assign)
expect_true(eb > sb)

# -- Children --
expect_true(ts_node_child_count(assign) >= 3L)
expect_true(ts_node_named_child_count(assign) >= 2L)

kids <- ts_node_children(assign)
expect_true(length(kids) >= 3L)

kids_named <- ts_node_children(assign, named = TRUE)
expect_true(length(kids_named) >= 2L)

# -- Named child navigation --
lhs <- ts_node_named_child(assign, 0L)
expect_equal(ts_node_type(lhs), "identifier")
expect_equal(ts_node_text(lhs), "f")

rhs <- ts_node_named_child(assign, 1L)
expect_equal(ts_node_type(rhs), "function_definition")

# -- Parent --
parent <- ts_node_parent(lhs)
expect_equal(ts_node_type(parent), "binary_operator")

# -- Siblings --
first <- ts_node_child(assign, 0L)
second <- ts_node_next_sibling(first)
expect_false(is.null(second))
back <- ts_node_prev_sibling(second)
expect_equal(ts_node_text(back), ts_node_text(first))

# -- Named siblings --
first_named <- ts_node_named_child(assign, 0L)
next_named <- ts_node_next_named_sibling(first_named)
expect_false(is.null(next_named))
expect_equal(ts_node_type(next_named), "function_definition")

# -- Child by field --
funcdef <- ts_node_named_child(assign, 1L)
params <- ts_node_child_by_field(funcdef, "parameters")
expect_false(is.null(params))
expect_equal(ts_node_type(params), "parameters")

body_node <- ts_node_child_by_field(funcdef, "body")
expect_false(is.null(body_node))

# -- Null node --
expect_true(ts_node_is_null(NULL))
no_field <- ts_node_child_by_field(root, "nonexistent")
expect_true(is.null(no_field))

# -- S-expression --
sexpr <- ts_node_sexpr(root)
expect_true(is.character(sexpr))
expect_true(grepl("program", sexpr))

# -- as.data.frame --
df <- as.data.frame(root)
expect_true(is.data.frame(df))
expect_true(nrow(df) > 1)
expect_true("type" %in% names(df))
expect_true("named" %in% names(df))
expect_true("text" %in% names(df))
expect_true("start_row" %in% names(df))
expect_true("start_byte" %in% names(df))
expect_equal(df$type[1], "program")
