% tinyrox says don't edit this manually, but it can't stop you!
\name{node_raw_s_expression}
\alias{node_raw_s_expression}
\title{The raw s-expression of a node}
\usage{
node_raw_s_expression(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single string.
}
\description{
The raw s-expression of a node
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  node_raw_s_expression(node)
}
}
