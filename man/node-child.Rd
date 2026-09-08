% tinyrox says don't edit this manually, but it can't stop you!
\name{node-child}
\alias{node_child}
\alias{node_named_child}
\title{Access a child by index (1-indexed)}
\usage{
node_child(x, i)

node_named_child(x, i)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}

\item{i}{A 1-indexed child position.}
}
\value{
A \code{tree_sitter_node}, or \code{NULL}.
}
\description{
Access a child by index (1-indexed)
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  expr <- node_child(tree_root_node(tree), 1)
  c(node_type(node_child(expr, 2)), node_type(node_named_child(expr, 2)))
}
}
