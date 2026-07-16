% tinyrox says don't edit this manually, but it can't stop you!
\name{node-state}
\alias{node-state}
\alias{node_is_error}
\alias{node_is_missing}
\alias{node_is_extra}
\title{Node error and state predicates}
\usage{
node-state(x)

node_is_error(x)

node_is_missing(x)

node_is_extra(x)
}
\arguments{
\item{x}{A `tree_sitter_node`.}
}
\value{
`TRUE` or `FALSE`.
}
\description{
- `node_has_error()` is `TRUE` if the node or any descendant is an error or
  is missing.
- `node_is_error()` is `TRUE` if the node itself is a syntax error.
- `node_is_missing()` is `TRUE` if the node is inserted by the parser to
  recover from an error.
- `node_is_extra()` is `TRUE` if the node is "extra" (e.g. a comment).
}
