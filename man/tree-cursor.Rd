% tinyrox says don't edit this manually, but it can't stop you!
\name{tree-cursor}
\alias{tree_walk}
\alias{node_walk}
\title{Walk a tree or node with a cursor}
\usage{
tree_walk(x)

node_walk(node)
}
\arguments{
\item{x}{A \code{tree_sitter_tree}.}

\item{node}{A \code{tree_sitter_node}.}
}
\value{
A \code{tree_sitter_tree_cursor}.
}
\description{
\code{tree_walk()} and \code{node_walk()} create a \code{tree_sitter_tree_cursor}, a mutable
cursor for efficient traversal. Navigate with its methods:
\code{cursor$goto_first_child()}, \code{cursor$goto_next_sibling()},
\code{cursor$goto_parent()} (each returns \code{TRUE}/\code{FALSE}), and read state with
\code{cursor$node()}, \code{cursor$field_name()}, and \code{cursor$depth()}.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  cursor <- tree_walk(text_parse("x <- 1", treesitter.r::language()))
  cursor$goto_first_child()
  node_type(cursor$node())
}
}
