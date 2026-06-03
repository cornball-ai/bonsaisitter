% tinyrox says don't edit this manually, but it can't stop you!
\name{as.data.frame.ts_node}
\alias{as.data.frame.ts_node}
\title{Convert a node to a data frame of descendants}
\usage{
\method{as.data.frame}{ts_node}(x, row.names = NULL, optional = FALSE, ...)
}
\arguments{
\item{x}{A \code{ts_node} object.}

\item{row.names}{Ignored.}

\item{optional}{Ignored.}

\item{...}{Ignored.}
}
\value{
A data frame with columns: type, named, text, start_row,
  start_col, end_row, end_col, start_byte, end_byte.
}
\description{
Convert a node to a data frame of descendants
}
