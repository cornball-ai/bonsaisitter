# bonsaisitter -> treesitter drop-in

Goal: `bonsaisitter::` substitutes for `treesitter::` at zero non-base deps.
Runtime + grammar already proven identical (byte-for-byte parse trees, ABI 14).
All work is in the R layer and C return shapes. Decisions: core first, kill the
`ts_*` names (no aliases), cursor in base R (not R6) when we get to it.

## Object model (match treesitter, base R)
- [x] `tree_sitter_language` = list(pointer, abi, name)
- [x] `tree_sitter_parser`   = list(language, pointer)
- [x] `tree_sitter_tree`     = list(pointer, text, language)
- [x] `tree_sitter_node`     = list(raw, tree)
- [x] `tree_sitter_point`    = list(row, column)
- [x] `tree_sitter_range`    = list(start_byte, start_point, end_byte, end_point)

## Phase 1 (core) -- this pass
- [x] C: node fns return bare raw; tree_root takes pointer; parse returns pointer
- [x] language_r/python/cpp, new_language, is_language, language_name
- [x] parser, parser_parse, parser_set_language, is_parser
- [x] tree_root_node, tree_text, tree_language, is_tree
- [x] node core: type/text/named/points/bytes/child(ren)/siblings/parent/field/s-expr
- [x] point, point_row, point_column, is_point
- [x] range + accessors, node_range, is_range
- [x] kill ts_* names; port audit_translation/literals_and_calls; drop old prints
- [x] equivalence smoke test vs treesitter

## Phase 2 (query) -- done
- [x] C bindings to ts_query_* ; query, query_captures, counts, is_query, print
- [x] query_captures byte-identical to treesitter (names + node texts)
- [ ] query_matches, predicates (#eq?/#match?), range restriction, byte-for-pattern

## Phase 3 (cursor, base R) -- done
- [x] TreeCursor via environment-of-closures (cur$goto_first_child()), no R6
- [x] tree_walk, node_walk, is_tree_cursor, print
- [ ] goto_last_child, goto_previous_sibling, reset, *_for_byte/point, field_id

## Runtime-only refactor -- done
- [x] Remove bundled grammars (tree-sitter-r/python/cpp) from src/; runtime only
- [x] Publish outboard grammar packages: treesitter.python (ABI 15),
      treesitter.cpp (ABI 14), mirroring the treesitter.r pattern (~/treesitter.*)
- [x] language.R keeps only consumer helpers (is_language, language_name, ...);
      no grammar construction. audit.R looks up grammars via requireNamespace.
- [x] Rely on treesitter.r now; grammar drift is moot (canonical grammar).
      treesitter.c once its Imports->Suggests is fixed. Tests skip when a grammar
      package is absent.
- [x] DESCRIPTION: runtime-only framing, zero hard deps; Suggests treesitter.r +
      treesitter (both on CRAN). treesitter.python/cpp NOT in Suggests (unpublished;
      reached via requireNamespace) per the CRAN-unpublished-Suggests rule.

## Publish follow-ups (outward-facing, needs go-ahead)
- [ ] gh repo create cornball-ai/treesitter.python and .cpp; push
- [ ] Add man/ (roxygen) + README + CI to the grammar packages before CRAN
- [ ] Only add treesitter.python/cpp to bonsaisitter Suggests once they are on CRAN

## Phase 4 (introspection tail) -- high-value subset done
- [x] node_has_error/is_error/is_missing/is_extra, node_descendant_count
- [x] node_grammar_type, node_language, text_parse
- [x] language_symbol_count/name/for_name, language_field_count/name_for_id/id_for_name
- [ ] node_child_by_field_id, node_field_name_for_child, node descendant-range lookups
- [ ] node_grammar_symbol/symbol, node_parse_state/next_parse_state, node states
- [ ] parser_reparse, parser_set_timeout, parser_set_included_ranges
- [ ] tree_included_ranges, tree_root_node_with_offset
- [ ] node_show_s_expression pretty printer (currently prints the raw s-expr)
