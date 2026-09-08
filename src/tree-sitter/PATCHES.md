# Local patches to the bundled tree-sitter sources

Upstream: the `lib/` subtree of tree-sitter
(https://github.com/tree-sitter/tree-sitter), from a 0.26-series snapshot
between the v0.26.6 and v0.26.7 tags: `lib/src/query.c` matches v0.26.6 and
`lib/src/parser.c` matches v0.26.7. Only `api.h` lives under
`lib/include/tree_sitter/`, as upstream.

Patches 1 and 2 exist because `R CMD check` rejects compiled code that can
call `abort()` or write to `stderr`. Patch 3 exists because CRAN policy
disallows pragmas that disable compiler diagnostics.

1. `lib/src/alloc.c`: the three default allocators no longer call
   `fprintf(stderr, ...)` and `abort()` on allocation failure; they return
   whatever `malloc`, `calloc` or `realloc` returned. bonsaisitter never
   uses these defaults: `R_init_bonsaisitter` in `src/init.c` registers
   replacements through `ts_set_allocator()` that raise an R error instead.

2. `lib/src/stack.c`, `ts_stack_print_dot_graph()`: a NULL `FILE *` now
   returns `false` instead of defaulting to `stderr`. The function is a
   debugging aid that bonsaisitter does not call.

3. `lib/src/array.h` and `lib/src/wasm_store.c`: the `#ifdef _MSC_VER` /
   `#pragma GCC diagnostic ignored` blocks (push and pop) are removed.
   array.h silenced `-Wunused-variable`, wasm_store.c silenced
   `-Wunused-parameter` around the wasm implementation, which bonsaisitter
   never compiles. Both files build without any warning under
   `-Wall -pedantic -Wextra` without the pragmas. CRAN's incoming pretest
   stops on the "pragmas suppressing diagnostics" NOTE.

Re-vendoring: copy upstream `lib/` over `src/tree-sitter/lib/`, re-apply
the hunks above, and update the version here and in `inst/COPYRIGHTS`.
