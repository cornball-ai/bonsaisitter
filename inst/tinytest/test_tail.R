library(bonsaisitter)

if (!requireNamespace("treesitter.r", quietly = TRUE)) exit_file("treesitter.r not installed")

lang <- treesitter.r::language()
p <- parser(lang)
tree <- parser_parse(p, "f <- function(x, y) x + y\n")
root <- tree_root_node(tree)
assign <- node_child(root, 1)

# -- Node symbols and parse states --
expect_true(node_symbol(assign) > 0)
expect_true(node_grammar_symbol(assign) > 0)
expect_true(node_parse_state(assign) >= 0)
expect_true(node_next_parse_state(assign) >= 0)

# -- Field id round-trip and field names --
fid <- language_field_id_for_name(lang, "lhs")
expect_true(fid > 0)
lhs <- node_child_by_field_id(assign, fid)
expect_equal(node_type(lhs), "identifier")
expect_equal(node_text(lhs), "f")
expect_equal(node_field_name_for_child(assign, 1), "lhs")

# -- Byte / point lookups --
expect_true(is_node(node_descendant_for_byte_range(root, 0, 1)))
expect_true(is_node(node_named_descendant_for_byte_range(root, 0, 1)))
expect_true(is_node(node_first_child_for_byte(root, 0)))
expect_true(is_node(node_descendant_for_point_range(root, point(0, 0), point(0, 1))))

# -- Language states --
expect_true(language_state_count(lang) > 0)

# -- Query matches --
q <- query(lang, "(binary_operator lhs: (_) @l rhs: (_) @r)")
ms <- query_matches(q, root)
expect_true(length(ms) >= 1)
expect_true(all(c("l", "r") %in% ms[[1]]$name))
expect_true(is_node(ms[[1]]$node[[1]]))
expect_equal(query_start_byte_for_pattern(q, 1), 0)
expect_true(query_end_byte_for_pattern(q, 1) > 0)

# -- Tree included ranges (default is the whole document) --
rngs <- tree_included_ranges(tree)
expect_true(length(rngs) >= 1)
expect_true(is_range(rngs[[1]]))

# -- Offset root --
off <- tree_root_node_with_offset(tree, 5, point(0, 5))
expect_true(is_node(off))
expect_equal(node_type(off), "program")
