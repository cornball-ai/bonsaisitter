library(bonsaisitter)

if (!requireNamespace("treesitter.r", quietly = TRUE)) exit_file("treesitter.r not installed")

lang <- treesitter.r::language()
p <- parser(lang)
root <- tree_root_node(parser_parse(p, "f(1, 2)\ng(3)\nh <- function(x) k(x)\n"))

# -- Compile + metadata --
q <- query(lang, "(call function: (identifier) @fn)")
expect_true(is_query(q))
expect_equal(query_pattern_count(q), 1)
expect_equal(query_capture_count(q), 1)
expect_equal(query_string_count(q), 0)

# -- Captures: names and nodes in traversal order --
caps <- query_captures(q, root)
expect_equal(caps$name, c("fn", "fn", "fn"))
expect_true(is_node(caps$node[[1]]))
texts <- vapply(caps$node, node_text, character(1))
expect_equal(texts, c("f", "g", "k"))

# -- A multi-capture pattern --
q2 <- query(lang, "(binary_operator lhs: (identifier) @lhs rhs: (_) @rhs)")
expect_equal(query_capture_count(q2), 2)
caps2 <- query_captures(q2, root)
expect_true("lhs" %in% caps2$name)
expect_true("h" %in% vapply(caps2$node, node_text, character(1)))

# -- Invalid query errors --
expect_error(query(lang, "(nonexistent_node)"))

expect_silent(print(q))
