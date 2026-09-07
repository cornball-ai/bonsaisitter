% tinyrox says don't edit this manually, but it can't stop you!
\name{is_query}
\alias{is_query}
\title{Is \code{x} a query?}
\usage{
is_query(x)
}
\arguments{
\item{x}{An object.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Is \code{x} a query?
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  is_query(query(treesitter.r::language(), "(identifier) @id"))
}
}
