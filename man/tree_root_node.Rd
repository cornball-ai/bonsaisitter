% tinyrox says don't edit this manually, but it can't stop you!
\name{tree_root_node}
\alias{tree_root_node}
\title{Retrieve the root node of a tree}
\usage{
tree_root_node(x)
}
\arguments{
\item{x}{A `tree_sitter_tree`.}
}
\value{
A `tree_sitter_node`.
}
\description{
Retrieve the root node of a tree
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  node_type(tree_root_node(tree))
}
}
