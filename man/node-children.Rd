% tinyrox says don't edit this manually, but it can't stop you!
\name{node-children}
\alias{node_children}
\alias{node_named_children}
\title{All children of a node}
\usage{
node_children(x)

node_named_children(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A list of \code{tree_sitter_node}s.
}
\description{
All children of a node
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  expr <- node_child(tree_root_node(tree), 1)
  vapply(node_children(expr), node_type, character(1))
  vapply(node_named_children(expr), node_type, character(1))
}
}
