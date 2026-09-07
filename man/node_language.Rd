% tinyrox says don't edit this manually, but it can't stop you!
\name{node_language}
\alias{node_language}
\title{The language of a node}
\usage{
node_language(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A \code{tree_sitter_language}.
}
\description{
The language of a node
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  language_name(node_language(node))
}
}
