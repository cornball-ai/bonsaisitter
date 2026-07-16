library(bonsaisitter)

if (!requireNamespace("treesitter.python", quietly = TRUE)) exit_file("treesitter.python not installed")

# -- Python language grammar --
lang <- treesitter.python::language()
expect_true(inherits(lang, "tree_sitter_language"))
parser <- parser(lang)

# -- Parse simple expression --
tree <- parser_parse(parser, "x = 1 + 2\n")
root <- tree_root_node(tree)
expect_equal(node_type(root), "module")
expect_equal(node_child_count(root), 1)

# -- Parse function definition --
code <- "def foo(x, y):\n    return x + y\n"
tree2 <- parser_parse(parser, code)
root2 <- tree_root_node(tree2)
func <- node_child(root2, 1)
expect_equal(node_type(func), "function_definition")

# Navigate by field name
name <- node_child_by_field_name(func, "name")
expect_equal(node_text(name), "foo")
params <- node_child_by_field_name(func, "parameters")
expect_equal(node_type(params), "parameters")
body <- node_child_by_field_name(func, "body")
expect_equal(node_type(body), "block")

# -- Parse class --
cls_code <- paste(
    "class MyModel(nn.Module):",
    "    def __init__(self):",
    "        super().__init__()",
    "    def forward(self, x):",
    "        return self.linear(x)",
    sep = "\n"
)
tree3 <- parser_parse(parser, cls_code)
root3 <- tree_root_node(tree3)
cls <- node_child(root3, 1)
expect_equal(node_type(cls), "class_definition")
cls_name <- node_child_by_field_name(cls, "name")
expect_equal(node_text(cls_name), "MyModel")
cls_body <- node_child_by_field_name(cls, "body")
expect_true(node_named_child_count(cls_body) >= 2)

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
tree4 <- parser_parse(parser, if_code)
root4 <- tree_root_node(tree4)
if_stmt <- node_child(root4, 1)
expect_equal(node_type(if_stmt), "if_statement")
sexpr4 <- node_raw_s_expression(if_stmt)
expect_true(grepl("elif_clause", sexpr4))
expect_true(grepl("else_clause", sexpr4))

# -- as.data.frame works with Python nodes --
df <- as.data.frame(root4)
expect_true(is.data.frame(df))
expect_true(nrow(df) > 1L)
expect_true("if_statement" %in% df$type)
