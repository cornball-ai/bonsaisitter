# bonsaisitter 0.1.2

Resubmission after CRAN's incoming pretest of 0.1.1, which stopped on the
"pragmas suppressing diagnostics" NOTE.

- Remove the `#pragma GCC diagnostic ignored` blocks, and their MSVC
  counterparts, from the bundled `lib/src/array.h` and
  `lib/src/wasm_store.c`. Both files compile without warnings without them.
  Recorded as patch 3 in `src/tree-sitter/PATCHES.md`. No other source
  changed.

# bonsaisitter 0.1.1

First CRAN submission; stopped by the incoming pretest on the pragma NOTE.

- Every exported function now has a runnable example. Examples that need a
  grammar are guarded on the 'treesitter.r' package.
- Drop the stale `src/Makevars.win`, which still listed grammar sources that
  left the package in 0.1.0. Windows builds now use `src/Makevars` like every
  other platform.
- Credit every author and copyright holder of the bundled tree-sitter sources
  in `Authors@R` and `inst/COPYRIGHTS`, and ship tree-sitter's MIT license text
  under `src/tree-sitter/`.
- Route tree-sitter's out-of-memory path through R's error handler instead of
  `abort()`; the two local patches to the bundled sources are listed in
  `src/tree-sitter/PATCHES.md`.
- Add Go, Rust and JavaScript grammars to the translation-audit path
  (`literals_and_calls()`, `audit_translation()`).
- Package documentation, README and DESCRIPTION describe the runtime-only
  design: grammars come from separate packages.

# bonsaisitter 0.1.0

Initial release on GitHub and the cornball.ai drat repository.

- Runtime-only bindings to the tree-sitter C library that mirror the
  'treesitter' package API: 91 exports. The R6 `TreeCursor` is replaced by the
  base-R `tree_walk()` / `node_walk()` cursor.
- Parser, tree, node, point, range, query and cursor objects; language and node
  introspection; incremental reparse and included ranges.
- Translation-audit helpers `literals_and_calls()` and `audit_translation()`.
- No package dependencies beyond base R.
