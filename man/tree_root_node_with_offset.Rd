% tinyrox says don't edit this manually, but it can't stop you!
\name{tree_root_node_with_offset}
\alias{tree_root_node_with_offset}
\title{An offset root node}
\usage{
tree_root_node_with_offset(x, byte, point)
}
\arguments{
\item{x}{A `tree_sitter_tree`.}

\item{byte}{A 0-indexed byte offset.}

\item{point}{A `tree_sitter_point` offset.}
}
\value{
A `tree_sitter_node`.
}
\description{
Returns the root node shifted forward by `byte` and `point`, so positions
read in the coordinate space of a larger document.
}
