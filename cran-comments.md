# cran-comments for bonsaisitter 0.1.2

## Resubmission

This is a resubmission. The incoming pretest of 0.1.1 (2026-09-08) stopped
on one NOTE, "pragmas in C/C++ headers and code", for two files in the
bundled tree-sitter sources: lib/src/array.h carried
`#pragma GCC diagnostic ignored "-Wunused-variable"` and
lib/src/wasm_store.c carried `"-Wunused-parameter"`.

Both pragma blocks are removed, with their MSVC counterparts. Nothing was
being suppressed on the platforms CRAN builds: the pretest's own logs
(Debian gcc 16, Windows gcc 14) show 0 compiler warnings with the pragmas
in place, and the pragma-free sources compile with 0 warnings locally
under `-Wall -pedantic -Wstrict-prototypes` and also under `-Wextra`. The
change is recorded as patch 3 in src/tree-sitter/PATCHES.md. No other
source changed.

## New submission

bonsaisitter binds the tree-sitter parsing library with an API that
mirrors the CRAN package 'treesitter', and has no package dependencies
beyond base R. It is the runtime only: grammars come from separate
packages, of which 'treesitter.r' is on CRAN and in Suggests.

## Bundled sources and copyright holders

src/tree-sitter/ bundles the lib/ subtree of the tree-sitter C library
(0.26 series; MIT, Max Brunsfeld; license text in src/tree-sitter/LICENSE).
Authors@R lists every author and copyright holder found by reading each
file header under that directory, and inst/COPYRIGHTS gives the per-file
detail:

- Max Brunsfeld, ctb and cph: the library.
- International Business Machines Corporation, cph, and Unicode, Inc.,
  cph: the three ICU UTF-8/UTF-16 headers that tree-sitter bundles under
  lib/src/unicode/, with ICU's license reproduced in that directory.
- Mathias Panzenböck, ctb: lib/src/portable/endian.h, which is public
  domain, so there is no holder to list.

Three local patches to the bundled sources are listed in
src/tree-sitter/PATCHES.md: two remove the abort() and stderr paths that
R CMD check flags (out-of-memory is routed through R's error handler
instead), the third removes the pragmas above.

## R CMD check results

0 errors | 0 warnings | 1 note

- New submission.

A local check also reports a compilation-flags note for flags that come
from the checking machine's R build, not from the package.

## Test environments

- Ubuntu 24.04, R 4.6.1, `R CMD check --as-cran`
- CRAN incoming pretest of 0.1.1: Debian R-devel (gcc 16) and Windows
  R-devel (gcc 14), 0 compiler warnings
- GitHub Actions: macos-latest (r-ci) and ubuntu-24.04 (r2u + rapt),
  the latter with every grammar package installed so the interop tests run
- win-builder: R-devel and R-release

## Examples and tests

Every example and test that needs a grammar is guarded on
`requireNamespace("treesitter.r")`. There is no `\dontrun{}`. Nothing is
written outside `tempdir()`; the test runner also redirects
`tools::R_user_dir()` into the check's temporary area.
