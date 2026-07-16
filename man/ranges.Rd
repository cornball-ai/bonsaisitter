% tinyrox says don't edit this manually, but it can't stop you!
\name{ranges}
\alias{ranges}
\alias{range_start_byte}
\alias{range_start_point}
\alias{range_end_byte}
\alias{range_end_point}
\alias{is_range}
\title{Ranges}
\usage{
ranges(start_byte, start_point, end_byte, end_point)

range_start_byte(x)

range_start_point(x)

range_end_byte(x)

range_end_point(x)

is_range(x)
}
\arguments{
\item{x}{A `tree_sitter_range`.}

\item{start_byte,end_byte}{Single whole numbers.}

\item{start_point,end_point}{`tree_sitter_point` objects.}
}
\value{
`range()` a range; accessors their component; `is_range()` a logical.
}
\description{
- `range()` creates a tree-sitter range from a start/end byte and point.
- `range_start_byte()`, `range_start_point()`, `range_end_byte()`, and
  `range_end_point()` access the components.
- `is_range()` tests for a range.

All bytes and points are 0-indexed.
}
