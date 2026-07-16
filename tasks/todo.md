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

## Phase 4 (introspection tail)
- [ ] language_symbol_*/field_*/state*, node_descendant_*/grammar_*/has_error/...
- [ ] parser_reparse, parser_set_timeout, parser_set_included_ranges
- [ ] tree_included_ranges, tree_root_node_with_offset
- [ ] node_show_s_expression pretty printer, print methods parity
