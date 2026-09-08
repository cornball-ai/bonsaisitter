% tinyrox says don't edit this manually, but it can't stop you!
\name{node-bytes}
\alias{node_start_byte}
\alias{node_end_byte}
\title{A node's start / end byte}
\usage{
node_start_byte(x)

node_end_byte(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single double (0-indexed).
}
\description{
A node's start / end byte
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  c(node_start_byte(node), node_end_byte(node))
}
}
