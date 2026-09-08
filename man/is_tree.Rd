% tinyrox says don't edit this manually, but it can't stop you!
\name{is_tree}
\alias{is_tree}
\title{Is \code{x} a tree?}
\usage{
is_tree(x)
}
\arguments{
\item{x}{An object.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Is \code{x} a tree?
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  is_tree(text_parse("x <- 1", treesitter.r::language()))
}
}
