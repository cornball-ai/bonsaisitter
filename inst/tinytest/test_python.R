library(bonsaisitter)

# -- Python language grammar --
parser <- ts_parser_new()
lang <- ts_language_python()
expect_true(inherits(lang, "ts_language"))
expect_true(ts_parser_set_language(parser, lang))

# -- Parse simple expression --
tree <- ts_parse(parser, "x = 1 + 2\n")
root <- ts_tree_root_node(tree)
expect_equal(ts_node_type(root), "module")
expect_equal(ts_node_child_count(root), 1L)

# -- Parse function definition --
code <- "def foo(x, y):\n    return x + y\n"
tree2 <- ts_parse(parser, code)
root2 <- ts_tree_root_node(tree2)
func <- ts_node_child(root2, 0L)
expect_equal(ts_node_type(func), "function_definition")

# Navigate by field name
name <- ts_node_child_by_field(func, "name")
expect_equal(ts_node_text(name), "foo")
params <- ts_node_child_by_field(func, "parameters")
expect_equal(ts_node_type(params), "parameters")
body <- ts_node_child_by_field(func, "body")
expect_equal(ts_node_type(body), "block")

# -- Parse class --
cls_code <- paste(
    "class MyModel(nn.Module):",
    "    def __init__(self):",
    "        super().__init__()",
    "    def forward(self, x):",
    "        return self.linear(x)",
    sep = "\n"
)
tree3 <- ts_parse(parser, cls_code)
root3 <- ts_tree_root_node(tree3)
cls <- ts_node_child(root3, 0L)
expect_equal(ts_node_type(cls), "class_definition")
cls_name <- ts_node_child_by_field(cls, "name")
expect_equal(ts_node_text(cls_name), "MyModel")
cls_body <- ts_node_child_by_field(cls, "body")
expect_true(ts_node_named_child_count(cls_body) >= 2L)

# -- Parse if/elif/else --
if_code <- paste(
    "if x > 0:",
    "    y = 1",
    "elif x < 0:",
    "    y = -1",
    "else:",
    "    y = 0",
    sep = "\n"
)
tree4 <- ts_parse(parser, if_code)
root4 <- ts_tree_root_node(tree4)
if_stmt <- ts_node_child(root4, 0L)
expect_equal(ts_node_type(if_stmt), "if_statement")
sexpr4 <- ts_node_sexpr(if_stmt)
expect_true(grepl("elif_clause", sexpr4))
expect_true(grepl("else_clause", sexpr4))

# -- as.data.frame works with Python nodes --
df <- as.data.frame(root4)
expect_true(is.data.frame(df))
expect_true(nrow(df) > 1L)
expect_true("if_statement" %in% df$type)
