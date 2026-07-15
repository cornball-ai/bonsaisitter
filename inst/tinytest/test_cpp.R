library(bonsaisitter)

# -- C++ language grammar --
parser <- ts_parser_new()
lang <- ts_language_cpp()
expect_true(inherits(lang, "ts_language"))
expect_true(ts_parser_set_language(parser, lang))

# -- Parse a simple declaration --
tree <- ts_parse(parser, "int x = 1 + 2;\n")
root <- ts_tree_root_node(tree)
expect_equal(ts_node_type(root), "translation_unit")
expect_equal(ts_node_child_count(root), 1L)

# -- Parse a free function definition, navigate by field --
code <- "int add(int x, int y) { return x + y; }\n"
tree2 <- ts_parse(parser, code)
root2 <- ts_tree_root_node(tree2)
fn <- ts_node_child(root2, 0L)
expect_equal(ts_node_type(fn), "function_definition")
decl <- ts_node_child_by_field(fn, "declarator")
expect_equal(ts_node_type(decl), "function_declarator")
body <- ts_node_child_by_field(fn, "body")
expect_equal(ts_node_type(body), "compound_statement")

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
tree3 <- ts_parse(parser, hdr)
root3 <- ts_tree_root_node(tree3)

# top-level node is the namespace
ns <- ts_node_child(root3, 0L)
expect_equal(ts_node_type(ns), "namespace_definition")
expect_equal(ts_node_text(ts_node_child_by_field(ns, "name")), "otio")

# the class, its name, and its members all show up in the s-expression
sx <- ts_node_sexpr(ns)
expect_true(grepl("class_specifier", sx))
expect_true(grepl("field_declaration", sx))    # method declarations
expect_true(grepl("function_declarator", sx))

# -- as.data.frame works with C++ nodes --
df <- as.data.frame(root3)
expect_true(is.data.frame(df))
expect_true(nrow(df) > 1L)
expect_true("class_specifier" %in% df$type)
expect_true("field_identifier" %in% df$type | "type_identifier" %in% df$type)
