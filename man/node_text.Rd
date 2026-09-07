% tinyrox says don't edit this manually, but it can't stop you!
\name{node_text}
\alias{node_text}
\title{The text underlying a node}
\usage{
node_text(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single string.
}
\description{
The text underlying a node
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- f(1)", treesitter.r::language()))
  node_text(node_child(node, 1))
}
}
