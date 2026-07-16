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

## Phase 2 (query) -- next
- [ ] C bindings to ts_query_* ; query, query_captures, query_matches + counts

## Phase 3 (cursor, base R) -- deferred
- [ ] TreeCursor via environment-of-closures (cur$goto_first_child()), no R6
- [ ] tree_walk, node_walk

## Known follow-ups
- [ ] Bundled tree-sitter-r grammar lags posit's treesitter.r 1.3.0: posit emits
      named `string_open`/`string_close` nodes for quotes, bundled emits anonymous
      `'`. 2/41 nodes differ on a string literal. Re-vendor the grammar to match,
      so bonsaisitter's *own* grammar is byte-identical too (consuming posit's
      grammar object is already byte-identical).

## Phase 4 (introspection tail)
- [ ] language_symbol_*/field_*/state*, node_descendant_*/grammar_*/has_error/...
- [ ] parser_reparse, parser_set_timeout, parser_set_included_ranges
- [ ] tree_included_ranges, tree_root_node_with_offset
- [ ] node_show_s_expression pretty printer, print methods parity
