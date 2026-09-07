% tinyrox says don't edit this manually, but it can't stop you!
\name{node-state}
\alias{node_has_error}
\alias{node_is_error}
\alias{node_is_missing}
\alias{node_is_extra}
\title{Node error and state predicates}
\usage{
node_has_error(x)

node_is_error(x)

node_is_missing(x)

node_is_extra(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
- \code{node_has_error()} is \code{TRUE} if the node or any descendant is an error or
  is missing.
- \code{node_is_error()} is \code{TRUE} if the node itself is a syntax error.
- \code{node_is_missing()} is \code{TRUE} if the node is inserted by the parser to
  recover from an error.
- \code{node_is_extra()} is \code{TRUE} if the node is "extra" (e.g. a comment).
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  lang <- treesitter.r::language()
  ok <- tree_root_node(text_parse("x <- 1", lang))
  broken <- tree_root_node(text_parse("x <- ", lang))
  c(node_has_error(ok), node_has_error(broken))
}
}
