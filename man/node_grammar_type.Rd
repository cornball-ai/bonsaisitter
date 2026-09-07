% tinyrox says don't edit this manually, but it can't stop you!
\name{node_grammar_type}
\alias{node_grammar_type}
\title{The grammar type of a node}
\usage{
node_grammar_type(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single string.
}
\description{
Like \code{\link{node_type}}, but returns the type as written in the grammar, ignoring
aliases.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  node_grammar_type(node)
}
}
