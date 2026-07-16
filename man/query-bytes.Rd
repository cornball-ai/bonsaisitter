% tinyrox says don't edit this manually, but it can't stop you!
\name{query-bytes}
\alias{query-bytes}
\alias{query_end_byte_for_pattern}
\title{Query byte ranges per pattern (1-indexed pattern)}
\usage{
query-bytes(x, i)

query_end_byte_for_pattern(x, i)
}
\arguments{
\item{x}{A `tree_sitter_query`.}

\item{i}{A 1-indexed pattern position.}
}
\value{
A single double (0-indexed byte).
}
\description{
Query byte ranges per pattern (1-indexed pattern)
}
