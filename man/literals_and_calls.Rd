% tinyrox says don't edit this manually, but it can't stop you!
\name{literals_and_calls}
\alias{literals_and_calls}
\title{Extract numeric literals and call names from source code}
\usage{
literals_and_calls(
  code,
  lang = c("r", "python", "cpp", "go", "rust", "javascript")
)
}
\arguments{
\item{code}{Character scalar of source code.}

\item{lang}{Language: \code{"r"} (default), \code{"python"},
\code{"cpp"}, \code{"go"}, \code{"rust"}, or \code{"javascript"}.}
}
\value{
A list with \code{literals} and \code{calls} (character vectors,
  in source order).
}
\description{
Parses \code{code} with tree-sitter and walks the AST collecting every
numeric literal (integer / float) and the callee name of every call. The
building block for \code{\link{audit_translation}}. Requires the grammar
package for \code{lang} (\code{treesitter.r}, \code{treesitter.python},
\code{treesitter.cpp}, \code{treesitter.go}, \code{treesitter.rust}, or
\code{treesitter.javascript}) to be installed.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  literals_and_calls("f(1L, 2.5) + g(3)")
}

}
