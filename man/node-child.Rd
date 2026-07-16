% tinyrox says don't edit this manually, but it can't stop you!
\name{node-child}
\alias{node-child}
\alias{node_named_child}
\title{Access a child by index (1-indexed)}
\usage{
node-child(x, i)

node_named_child(x, i)
}
\arguments{
\item{x}{A `tree_sitter_node`.}

\item{i}{A 1-indexed child position.}
}
\value{
A `tree_sitter_node`, or `NULL`.
}
\description{
Access a child by index (1-indexed)
}
