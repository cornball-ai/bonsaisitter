library(bonsaisitter)

if (!requireNamespace("treesitter.cpp", quietly = TRUE)) exit_file("treesitter.cpp not installed")

# -- C++ language grammar --
lang <- treesitter.cpp::language()
expect_true(inherits(lang, "tree_sitter_language"))
parser <- parser(lang)

# -- Parse a simple declaration --
tree <- parser_parse(parser, "int x = 1 + 2;\n")
root <- tree_root_node(tree)
expect_equal(node_type(root), "translation_unit")
expect_equal(node_child_count(root), 1)

# -- Parse a free function definition, navigate by field --
code <- "int add(int x, int y) { return x + y; }\n"
tree2 <- parser_parse(parser, code)
root2 <- tree_root_node(tree2)
fn <- node_child(root2, 1)
expect_equal(node_type(fn), "function_definition")
decl <- node_child_by_field_name(fn, "declarator")
expect_equal(node_type(decl), "function_declarator")
body <- node_child_by_field_name(fn, "body")
expect_equal(node_type(body), "compound_statement")

# -- Parse an OTIO-flavoured namespaced class with method declarations --
hdr <- paste(
    "namespace otio {",
    "class RationalTime {",
    "public:",
    "    RationalTime(double value, double rate);",
    "    double to_seconds() const;",
    "    int to_frames(double rate) const;",
    "private:",
    "    double _value;",
    "    double _rate;",
    "};",
    "}",
    sep = "\n"
)
tree3 <- parser_parse(parser, hdr)
root3 <- tree_root_node(tree3)

# top-level node is the namespace
ns <- node_child(root3, 1)
expect_equal(node_type(ns), "namespace_definition")
expect_equal(node_text(node_child_by_field_name(ns, "name")), "otio")

# the class, its name, and its members all show up in the s-expression
sx <- node_raw_s_expression(ns)
expect_true(grepl("class_specifier", sx))
expect_true(grepl("field_declaration", sx))    # method declarations
expect_true(grepl("function_declarator", sx))

# -- as.data.frame works with C++ nodes --
df <- as.data.frame(root3)
expect_true(is.data.frame(df))
expect_true(nrow(df) > 1L)
expect_true("class_specifier" %in% df$type)
expect_true("field_identifier" %in% df$type | "type_identifier" %in% df$type)
