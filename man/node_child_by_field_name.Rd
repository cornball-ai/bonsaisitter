% tinyrox says don't edit this manually, but it can't stop you!
\name{node_child_by_field_name}
\alias{node_child_by_field_name}
\title{A child by field name}
\usage{
node_child_by_field_name(x, name)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}

\item{name}{A field name.}
}
\value{
A \code{tree_sitter_node}, or \code{NULL}.
}
\description{
A child by field name
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  expr <- node_child(tree_root_node(tree), 1)
  node_text(node_child_by_field_name(expr, "lhs"))
}
}
