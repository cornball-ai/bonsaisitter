% tinyrox says don't edit this manually, but it can't stop you!
\name{node_range}
\alias{node_range}
\title{A node's range}
\usage{
node_range(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A \code{tree_sitter_range}.
}
\description{
A node's range
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  node_range(node)
}
}
