#' Extract numeric literals and call names from source code
#'
#' Parses \code{code} with tree-sitter and walks the AST collecting every
#' numeric literal (integer / float) and the callee name of every call. The
#' building block for \code{\link{audit_translation}}.
#'
#' @param code Character scalar of source code.
#' @param lang Language: \code{"r"} (default), \code{"python"}, or
#'   \code{"cpp"}.
#'
#' @return A list with \code{literals} and \code{calls} (character vectors,
#'   in source order).
#'
#' @examples
#' literals_and_calls("f(1L, 2.5) + g(3)")
#'
#' @export
literals_and_calls <- function(code, lang = c("r", "python", "cpp")) {
  lang <- match.arg(lang)
  language <- switch(lang,
    r = language_r(), python = language_python(), cpp = language_cpp())
  root <- tree_root_node(parser_parse(parser(language), code))
  nums <- character(0)
  calls <- character(0)
  walk <- function(n) {
    ty <- node_type(n)
    if (ty %in% c("float", "integer", "complex")) {
      nums <<- c(nums, node_text(n))
    }
    if (ty == "call") {
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
#' @param lang Language of both (\code{"r"}, \code{"python"}, \code{"cpp"}).
#'   Pass a length-2 vector to parse reference and port as different
#'   languages (e.g. \code{c("python", "r")}).
#' @param normalize Logical; strip \code{L} suffixes and coerce so
#'   \code{4.0 == 4L == 4}.
#'
#' @return A list: \code{literals_missing} (in reference, not port),
#'   \code{literals_extra} (in port, not reference), and the full
#'   \code{reference} / \code{port} extractions.
#'
#' @examples
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
