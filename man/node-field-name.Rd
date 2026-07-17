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
\item{x}{A `tree_sitter_node`.}

\item{i}{A 1-indexed child position.}
}
\value{
A single string, or `NA` if the child has no field.
}
\description{
Field name for a child (1-indexed)
}
