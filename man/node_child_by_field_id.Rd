% tinyrox says don't edit this manually, but it can't stop you!
\name{node_child_by_field_id}
\alias{node_child_by_field_id}
\title{A child by field id}
\usage{
node_child_by_field_id(x, id)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}

\item{id}{A field id (see \code{\link{language_field_id_for_name}}).}
}
\value{
A \code{tree_sitter_node}, or \code{NULL}.
}
\description{
A child by field id
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  lang <- treesitter.r::language()
  expr <- node_child(tree_root_node(text_parse("x <- 1", lang)), 1)
  id <- language_field_id_for_name(lang, "lhs")
  node_text(node_child_by_field_id(expr, id))
}
}
