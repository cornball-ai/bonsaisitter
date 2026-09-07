% tinyrox says don't edit this manually, but it can't stop you!
\name{text_parse}
\alias{text_parse}
\title{Parse text in one step}
\usage{
text_parse(x, language)
}
\arguments{
\item{x}{A single string to parse.}

\item{language}{A \code{tree_sitter_language}.}
}
\value{
A \code{tree_sitter_tree}.
}
\description{
\code{text_parse()} is a convenience wrapper that builds a parser for \code{language}
and parses \code{x} with it, returning the tree directly.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("f <- function(x) x + 1", treesitter.r::language())
  node_type(tree_root_node(tree))
}
}
