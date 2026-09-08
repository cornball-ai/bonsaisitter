% tinyrox says don't edit this manually, but it can't stop you!
\name{query_matches}
\alias{query_matches}
\title{Run a query and collect its matches}
\usage{
query_matches(x, node)
}
\arguments{
\item{x}{A \code{tree_sitter_query}.}

\item{node}{A \code{tree_sitter_node} to search within.}
}
\value{
A list of matches.
}
\description{
Unlike treesitter, which nests matches by pattern, this returns a flat list
of matches. Each match is \code{list(pattern, name, node)}: the 0-indexed pattern,
the capture names, and the captured \code{tree_sitter_node}s.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  lang <- treesitter.r::language()
  node <- tree_root_node(text_parse("f(1); g(2)", lang))
  q <- query(lang, "(call function: (identifier) @fn)")
  matches <- query_matches(q, node)
  vapply(matches, function(m) node_text(m$node[[1]]), character(1))
}
}
