% tinyrox says don't edit this manually, but it can't stop you!
\name{query_matches}
\alias{query_matches}
\title{Run a query and collect its matches}
\usage{
query_matches(x, node)
}
\arguments{
\item{x}{A `tree_sitter_query`.}

\item{node}{A `tree_sitter_node` to search within.}
}
\value{
A list of matches.
}
\description{
Unlike treesitter, which nests matches by pattern, this returns a flat list
of matches. Each match is `list(pattern, name, node)`: the 0-indexed pattern,
the capture names, and the captured `tree_sitter_node`s.
}
