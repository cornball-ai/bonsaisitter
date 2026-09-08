% tinyrox says don't edit this manually, but it can't stop you!
\name{is_node}
\alias{is_node}
\title{Is \code{x} a node?}
\usage{
is_node(x)
}
\arguments{
\item{x}{An object.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Is \code{x} a node?
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x + 1", treesitter.r::language()))
  c(is_node(node), is_node("x + 1"))
}
}
