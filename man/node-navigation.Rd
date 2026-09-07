% tinyrox says don't edit this manually, but it can't stop you!
\name{node-navigation}
\alias{node_parent}
\alias{node_next_sibling}
\alias{node_previous_sibling}
\alias{node_next_named_sibling}
\alias{node_previous_named_sibling}
\title{Sibling and parent navigation}
\usage{
node_parent(x)

node_next_sibling(x)

node_previous_sibling(x)

node_next_named_sibling(x)

node_previous_named_sibling(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A \code{tree_sitter_node}, or \code{NULL}.
}
\description{
Sibling and parent navigation
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  lhs <- node_child_by_field_name(node_child(tree_root_node(tree), 1), "lhs")
  c(node_type(node_parent(lhs)), node_type(node_next_sibling(lhs)),
    node_type(node_next_named_sibling(lhs)))
}
}
