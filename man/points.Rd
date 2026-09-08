% tinyrox says don't edit this manually, but it can't stop you!
\name{points}
\alias{point}
\alias{point_row}
\alias{point_column}
\alias{is_point}
\title{Points}
\usage{
point(row, column)

point_row(x)

point_column(x)

is_point(x)
}
\arguments{
\item{x}{A \code{tree_sitter_point}.}

\item{row,column}{A 0-indexed row / column (single whole number).}
}
\value{
\code{point()} a point; the accessors a double; \code{is_point()} a logical.
}
\description{
- \code{point()} creates a tree-sitter point. Points are 0-indexed.
- \code{point_row()} and \code{point_column()} access the row and column.
- \code{is_point()} tests for a point.
}
\examples{
p <- point(2, 4)
p
point_row(p)
point_column(p)
is_point(p)
}
