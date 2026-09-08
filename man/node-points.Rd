% tinyrox says don't edit this manually, but it can't stop you!
\name{node-points}
\alias{node_start_point}
\alias{node_end_point}
\title{A node's start / end point}
\usage{
node_start_point(x)

node_end_point(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A \code{tree_sitter_point}.
}
\description{
A node's start / end point
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1\ny <- 2", treesitter.r::language()))
  node_start_point(node)
  node_end_point(node)
}
}
