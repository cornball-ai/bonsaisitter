% tinyrox says don't edit this manually, but it can't stop you!
\name{node-child-count}
\alias{node_child_count}
\alias{node_named_child_count}
\title{Child counts}
\usage{
node_child_count(x)

node_named_child_count(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single double.
}
\description{
Child counts
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  expr <- node_child(tree_root_node(tree), 1)
  c(node_child_count(expr), node_named_child_count(expr))
}
}
