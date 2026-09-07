% tinyrox says don't edit this manually, but it can't stop you!
\name{ranges}
\alias{range}
\alias{range_start_byte}
\alias{range_start_point}
\alias{range_end_byte}
\alias{range_end_point}
\alias{is_range}
\title{Ranges}
\usage{
range(start_byte, start_point, end_byte, end_point)

range_start_byte(x)

range_start_point(x)

range_end_byte(x)

range_end_point(x)

is_range(x)
}
\arguments{
\item{x}{A \code{tree_sitter_range}.}

\item{start_byte,end_byte}{Single whole numbers.}

\item{start_point,end_point}{\code{tree_sitter_point} objects.}
}
\value{
\code{range()} a range; accessors their component; \code{is_range()} a logical.
}
\description{
- \code{range()} creates a tree-sitter range from a start/end byte and point.
- \code{range_start_byte()}, \code{range_start_point()}, \code{range_end_byte()}, and
  \code{range_end_point()} access the components.
- \code{is_range()} tests for a range.

All bytes and points are 0-indexed.
}
\examples{
r <- range(0, point(0, 0), 6, point(0, 6))
r
range_end_byte(r)
range_end_point(r)
is_range(r)
}
