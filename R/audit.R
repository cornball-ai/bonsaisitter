# Look up a grammar from its (Suggested) package. Kept as a runtime-side helper
# so the grammar packages stay optional -- requireNamespace, not Imports, and
# not listed in Suggests when they are not yet on CRAN.
grammar_language <- function(lang) {
  pkg <- switch(lang,
    r = "treesitter.r",
    python = "treesitter.python",
    cpp = "treesitter.cpp",
    go = "treesitter.go"
  )
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(sprintf(
      "The '%s' grammar package is required to parse %s code. Install it first.",
      pkg, lang
    ), call. = FALSE)
  }
  getExportedValue(pkg, "language")()
}

# Node type names are per-grammar, so the literal and call nodes have to be
# looked up rather than assumed. Assuming is silent: the walk matches nothing,
# the audit finds no drift, and that reads as a clean port instead of one that
# was never inspected. Every grammar here names the callee field "function".
grammar_nodes <- function(lang) {
  switch(lang,
    r = list(
      numbers = c("float", "integer", "complex"),
      call = "call"
    ),
    python = list(
      numbers = c("float", "integer"),
      call = "call"
    ),
    cpp = list(
      numbers = "number_literal",
      call = "call_expression"
    ),
    go = list(
      numbers = c("int_literal", "float_literal", "imaginary_literal"),
      call = "call_expression"
    )
  )
}

#' Extract numeric literals and call names from source code
#'
#' Parses \code{code} with tree-sitter and walks the AST collecting every
#' numeric literal (integer / float) and the callee name of every call. The
#' building block for \code{\link{audit_translation}}. Requires the grammar
#' package for \code{lang} (\code{treesitter.r}, \code{treesitter.python},
#' \code{treesitter.cpp}, or \code{treesitter.go}) to be installed.
#'
#' @param code Character scalar of source code.
#' @param lang Language: \code{"r"} (default), \code{"python"},
#'   \code{"cpp"}, or \code{"go"}.
#'
#' @return A list with \code{literals} and \code{calls} (character vectors,
#'   in source order).
#'
#' @examplesIf requireNamespace("treesitter.r", quietly = TRUE)
#' literals_and_calls("f(1L, 2.5) + g(3)")
#'
#' @export
literals_and_calls <- function(code, lang = c("r", "python", "cpp", "go")) {
  lang <- match.arg(lang)
  nodes <- grammar_nodes(lang)
  root <- tree_root_node(parser_parse(parser(grammar_language(lang)), code))
  nums <- character(0)
  calls <- character(0)
  walk <- function(n) {
    ty <- node_type(n)
    if (ty %in% nodes$numbers) {
      nums <<- c(nums, node_text(n))
    }
    if (ty == nodes$call) {
      fn <- node_child_by_field_name(n, "function")
      if (!is.null(fn)) calls <<- c(calls, node_text(fn))
    }
    for (ch in node_children(n)) walk(ch)
  }
  walk(root)
  list(literals = nums, calls = calls)
}

#' Audit a code translation for drifted numeric constants
#'
#' Compares a reference scope (e.g. the original Python or torch code) with
#' its port, reporting numeric literals present in one but not the other.
#' Parity tests prove the paths they exercise; this catches the drift they
#' do not -- wrong constants, dropped operations, unported branches. Call
#' names are returned too for eyeballing with a noise filter.
#'
#' Numeric literals are normalized by default so \code{4.0}, \code{4L}, and
#' \code{4} compare equal.
#'
#' @param reference Character scalar of reference source.
#' @param port Character scalar of the port's source.
#' @param lang Language of both (\code{"r"}, \code{"python"}, \code{"cpp"},
#'   \code{"go"}). Pass a length-2 vector to parse reference and port as
#'   different languages (e.g. \code{c("python", "r")}).
#' @param normalize Logical; strip \code{L} suffixes and coerce so
#'   \code{4.0 == 4L == 4}.
#'
#' @return A list: \code{literals_missing} (in reference, not port),
#'   \code{literals_extra} (in port, not reference), and the full
#'   \code{reference} / \code{port} extractions.
#'
#' @examplesIf requireNamespace("treesitter.r", quietly = TRUE)
#' audit_translation("clamp(x, 1e-10); y * 8", "pmax(x, 1e-10); y * 8")
#'
#' @export
audit_translation <- function(reference, port, lang = "r", normalize = TRUE) {
  lang <- rep_len(lang, 2L)
  ref <- literals_and_calls(reference, lang[1L])
  prt <- literals_and_calls(port, lang[2L])
  norm <- if (normalize) {
    function(v) as.character(as.numeric(sub("L$", "", v)))
  } else {
    identity
  }
  rn <- unique(norm(ref$literals))
  pn <- unique(norm(prt$literals))
  list(
    literals_missing = setdiff(rn, pn),
    literals_extra = setdiff(pn, rn),
    reference = ref,
    port = prt
  )
}
