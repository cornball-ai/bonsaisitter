# treesitR

Tinyverse tree-sitter bindings for R. Zero R package dependencies, base R only.

## Architecture

- C bindings in `src/treesitr_*.c` wrap tree-sitter C API
- TSNode stored as raw vector (`sizeof(TSNode)` bytes) + reference to tree for GC protection
- Tree objects are lists with `$ptr` (externalptr) and `$source` (character)
- Vendored: tree-sitter core in `src/tree-sitter/`, R grammar in `src/tree-sitter-r/`

## Build

```bash
r -e 'tinyrox::document(); tinypkgr::install()'
r -e 'tinytest::test_package("treesitR")'
```
