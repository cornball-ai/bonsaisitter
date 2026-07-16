% tinyrox says don't edit this manually, but it can't stop you!
\name{node-navigation}
\alias{node-navigation}
\alias{node_next_sibling}
\alias{node_previous_sibling}
\alias{node_next_named_sibling}
\alias{node_previous_named_sibling}
\title{Sibling and parent navigation}
\usage{
node-navigation(x)

node_next_sibling(x)

node_previous_sibling(x)

node_next_named_sibling(x)

node_previous_named_sibling(x)
}
\arguments{
\item{x}{A `tree_sitter_node`.}
}
\value{
A `tree_sitter_node`, or `NULL`.
}
\description{
Sibling and parent navigation
}
