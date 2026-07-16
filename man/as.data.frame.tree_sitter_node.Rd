% tinyrox says don't edit this manually, but it can't stop you!
\name{as.data.frame.tree_sitter_node}
\alias{as.data.frame.tree_sitter_node}
\title{Convert a node's descendants to a data frame}
\usage{
\method{as.data.frame}{tree_sitter_node}(x, row.names = NULL, optional = FALSE,
                                         ...)
}
\arguments{
\item{x}{A `tree_sitter_node`.}

\item{row.names}{Ignored.}

\item{optional}{Ignored.}

\item{...}{Ignored.}
}
\value{
A base data frame with columns: type, named, text, start_row,
  start_col, end_row, end_col, start_byte, end_byte.
}
\description{
Convert a node's descendants to a data frame
}
