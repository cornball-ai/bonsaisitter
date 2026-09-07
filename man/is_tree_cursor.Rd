% tinyrox says don't edit this manually, but it can't stop you!
\name{is_tree_cursor}
\alias{is_tree_cursor}
\title{Is \code{x} a tree cursor?}
\usage{
is_tree_cursor(x)
}
\arguments{
\item{x}{An object.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Is \code{x} a tree cursor?
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  is_tree_cursor(tree_walk(text_parse("x <- 1", treesitter.r::language())))
}
}
