# bonsaisitter

Bindings to the [tree-sitter](https://tree-sitter.github.io/tree-sitter/)
parsing library for R. The API mirrors the
[treesitter](https://cran.r-project.org/package=treesitter) package, so
`bonsaisitter::` can stand in for `treesitter::` in existing code. The package
depends on nothing beyond base R.

bonsaisitter is the runtime only. Grammars come from separate packages:

| Language   | Package                                                                    | Where       |
|------------|----------------------------------------------------------------------------|-------------|
| R          | [treesitter.r](https://cran.r-project.org/package=treesitter.r)            | CRAN        |
| Python     | [treesitter.python](https://github.com/cornball-ai/treesitter.python)      | GitHub, drat |
| C++        | [treesitter.cpp](https://github.com/cornball-ai/treesitter.cpp)            | GitHub, drat |
| Go         | [treesitter.go](https://github.com/cornball-ai/treesitter.go)              | GitHub, drat |
| Rust       | [treesitter.rust](https://github.com/cornball-ai/treesitter.rust)          | GitHub, drat |
| JavaScript | [treesitter.javascript](https://github.com/cornball-ai/treesitter.javascript) | GitHub, drat |

## Installation

```r
install.packages("bonsaisitter")
```

Development builds and the grammar packages that are not on CRAN are in the
cornball.ai drat repository:

```r
install.packages(c("bonsaisitter", "treesitter.python"),
                 repos = "https://cornball-ai.github.io/drat")
```

## Usage

```r
library(bonsaisitter)

lang <- treesitter.r::language()
tree <- text_parse("x <- f(1, 2)", lang)
root <- tree_root_node(tree)

node_type(root)
#> [1] "program"

q <- query(lang, "(call function: (identifier) @fn)")
vapply(query_captures(q, root)$node, node_text, character(1))
#> [1] "f"

cursor <- tree_walk(tree)
cursor$goto_first_child()
node_type(cursor$node())
#> [1] "binary_operator"
```

## Differences from treesitter

- The R6 `TreeCursor` is replaced by `tree_walk()` and `node_walk()`, which
  return an environment of closures with the same method names
  (`cursor$goto_first_child()`, `cursor$node()`, and so on).
- `query_matches()` returns a flat list of matches instead of nesting them by
  pattern.
- Query predicates such as `#eq?` and `#match?` are not applied;
  `query_captures()` returns every capture.

## Extras

- `literals_and_calls()` and `audit_translation()` compare the numeric
  literals and call names of a source file and its port, for example Python
  code and its R translation, and report the constants that drifted.
- `as.data.frame()` on a node gives one row per descendant, with type, text
  and position columns.

## License

MIT, copyright cornball.ai. The bundled tree-sitter sources are MIT, copyright
Max Brunsfeld; every holder is listed in `inst/COPYRIGHTS`.
