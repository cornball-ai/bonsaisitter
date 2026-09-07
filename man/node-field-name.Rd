% tinyrox says don't edit this manually, but it can't stop you!
\name{node-field-name}
\alias{node_field_name_for_child}
\alias{node_field_name_for_named_child}
\title{Field name for a child (1-indexed)}
\usage{
node_field_name_for_child(x, i)

node_field_name_for_named_child(x, i)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}

\item{i}{A 1-indexed child position.}
}
\value{
A single string, or \code{NA} if the child has no field.
}
\description{
Field name for a child (1-indexed)
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  expr <- node_child(tree_root_node(tree), 1)
  c(node_field_name_for_child(expr, 1), node_field_name_for_named_child(expr, 2))
}
}
