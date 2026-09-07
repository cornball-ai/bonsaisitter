% tinyrox says don't edit this manually, but it can't stop you!
\name{node_descendant_count}
\alias{node_descendant_count}
\title{The number of descendants of a node}
\usage{
node_descendant_count(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single double, including the node itself.
}
\description{
The number of descendants of a node
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  node_descendant_count(node)
}
}
