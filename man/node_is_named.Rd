% tinyrox says don't edit this manually, but it can't stop you!
\name{node_is_named}
\alias{node_is_named}
\title{Is a node named?}
\usage{
node_is_named(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Is a node named?
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  expr <- node_child(tree_root_node(tree), 1)
  vapply(node_children(expr), node_is_named, logical(1))
}
}
