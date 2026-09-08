% tinyrox says don't edit this manually, but it can't stop you!
\name{parser}
\alias{parser}
\title{Create a parser}
\usage{
parser(language)
}
\arguments{
\item{language}{A \code{tree_sitter_language}, e.g. from a grammar package like
\code{treesitter.r::language()}.}
}
\value{
A \code{tree_sitter_parser}.
}
\description{
\code{parser()} constructs a parser from a \code{tree_sitter_language}. Use
\code{\link{parser_parse}} to parse text with it.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  p <- parser(treesitter.r::language())
  tree <- parser_parse(p, "x <- f(1, 2)")
  node_type(tree_root_node(tree))
}
}
