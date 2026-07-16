library(bonsaisitter)

if (!requireNamespace("treesitter.r", quietly = TRUE)) exit_file("treesitter.r not installed")

lang <- treesitter.r::language()

# -- Timeout stored and a normal parse under a generous limit still works --
p <- parser_set_timeout(parser(lang), 5e6)   # 5 seconds, in microseconds
expect_equal(p$timeout, 5e6)
tree <- parser_parse(p, "x <- 1 + 2\n")
expect_equal(node_type(tree_root_node(tree)), "program")

# -- Included ranges round-trip through the parser --
r1 <- range(0, point(0, 0), 6, point(0, 6))
p2 <- parser_set_included_ranges(parser(lang), list(r1))
expect_equal(length(p2$included_ranges), 1)
t2 <- parser_parse(p2, "x <- 1\ny <- 2\n")
expect_true(is_tree(t2))
inc <- tree_included_ranges(t2)
expect_equal(range_start_byte(inc[[1]]), 0)
expect_equal(range_end_byte(inc[[1]]), 6)

# -- Clearing included ranges restores the whole document --
p3 <- parser_set_included_ranges(p2, list())
expect_equal(length(p3$included_ranges), 0)

# -- Incremental reparse; the original tree is left intact --
p4 <- parser(lang)
text1 <- "x <- 1 + foo\n"
tree1 <- parser_parse(p4, text1)
text2 <- "x <- 1 + bar(foo)\n"
tree2 <- parser_reparse(
    p4, text2, tree1,
    start_byte = 9, start_point = point(0, 9),
    old_end_byte = 12, old_end_point = point(0, 12),
    new_end_byte = 17, new_end_point = point(0, 17)
)
expect_true(is_tree(tree2))
expect_equal(tree_text(tree2), text2)
expect_true(grepl("call", node_raw_s_expression(tree_root_node(tree2))))
# original tree unchanged: it has no call node
expect_false(grepl("call", node_raw_s_expression(tree_root_node(tree1))))
