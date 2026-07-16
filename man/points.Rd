% tinyrox says don't edit this manually, but it can't stop you!
\name{points}
\alias{points}
\alias{point_row}
\alias{point_column}
\alias{is_point}
\title{Points}
\usage{
points(row, column)

point_row(x)

point_column(x)

is_point(x)
}
\arguments{
\item{x}{A `tree_sitter_point`.}

\item{row,column}{A 0-indexed row / column (single whole number).}
}
\value{
`point()` a point; the accessors a double; `is_point()` a logical.
}
\description{
- `point()` creates a tree-sitter point. Points are 0-indexed.
- `point_row()` and `point_column()` access the row and column.
- `is_point()` tests for a point.
}
