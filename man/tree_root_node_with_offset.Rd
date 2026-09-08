% tinyrox says don't edit this manually, but it can't stop you!
\name{tree_root_node_with_offset}
\alias{tree_root_node_with_offset}
\title{An offset root node}
\usage{
tree_root_node_with_offset(x, byte, point)
}
\arguments{
\item{x}{A \code{tree_sitter_tree}.}

\item{byte}{A 0-indexed byte offset.}

\item{point}{A \code{tree_sitter_point} offset.}
}
\value{
A \code{tree_sitter_node}.
}
\description{
Returns the root node shifted forward by \code{byte} and \code{point}, so positions
read in the coordinate space of a larger document.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  node <- tree_root_node_with_offset(tree, 10, point(2, 0))
  node_start_point(node)
}
}
