% tinyrox says don't edit this manually, but it can't stop you!
\name{is_language}
\alias{is_language}
\title{Is \code{x} a language?}
\usage{
is_language(x)
}
\arguments{
\item{x}{An object.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Is \code{x} a language?
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  is_language(treesitter.r::language())
}
}
