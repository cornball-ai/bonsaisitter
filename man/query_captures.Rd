% tinyrox says don't edit this manually, but it can't stop you!
\name{query_captures}
\alias{query_captures}
\title{Run a query and collect its captures}
\usage{
query_captures(x, node)
}
\arguments{
\item{x}{A `tree_sitter_query`.}

\item{node}{A `tree_sitter_node` to search within.}
}
\value{
A list with `name` (character vector of capture names) and `node`
  (list of `tree_sitter_node`s), one entry per capture in traversal order.
}
\description{
Run a query and collect its captures
}
