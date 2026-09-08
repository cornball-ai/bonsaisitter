% tinyrox says don't edit this manually, but it can't stop you!
\name{node_type}
\alias{node_type}
\title{The type of a node}
\usage{
node_type(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single string.
}
\description{
The type of a node
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x + 1", treesitter.r::language()))
  node_type(node)
}
}
