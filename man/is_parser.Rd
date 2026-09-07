% tinyrox says don't edit this manually, but it can't stop you!
\name{is_parser}
\alias{is_parser}
\title{Is \code{x} a parser?}
\usage{
is_parser(x)
}
\arguments{
\item{x}{An object.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Is \code{x} a parser?
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  is_parser(parser(treesitter.r::language()))
}
}
