% tinyrox says don't edit this manually, but it can't stop you!
\name{query-bytes}
\alias{query_start_byte_for_pattern}
\alias{query_end_byte_for_pattern}
\title{Query byte ranges per pattern (1-indexed pattern)}
\usage{
query_start_byte_for_pattern(x, i)

query_end_byte_for_pattern(x, i)
}
\arguments{
\item{x}{A \code{tree_sitter_query}.}

\item{i}{A 1-indexed pattern position.}
}
\value{
A single double (0-indexed byte).
}
\description{
Query byte ranges per pattern (1-indexed pattern)
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  q <- query(treesitter.r::language(), "(call) @call (identifier) @id")
  c(query_start_byte_for_pattern(q, 2), query_end_byte_for_pattern(q, 2))
}
}
