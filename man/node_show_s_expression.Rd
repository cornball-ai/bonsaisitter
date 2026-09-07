% tinyrox says don't edit this manually, but it can't stop you!
\name{node_show_s_expression}
\alias{node_show_s_expression}
\title{Show a node's s-expression}
\usage{
node_show_s_expression(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
\code{x}, invisibly, called for its side effect of printing.
}
\description{
Show a node's s-expression
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  node_show_s_expression(node)
}
}
