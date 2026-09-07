% tinyrox says don't edit this manually, but it can't stop you!
\name{node-locate}
\alias{node_first_child_for_byte}
\alias{node_first_named_child_for_byte}
\alias{node_descendant_for_byte_range}
\alias{node_named_descendant_for_byte_range}
\alias{node_descendant_for_point_range}
\alias{node_named_descendant_for_point_range}
\title{Locate nodes by byte or point}
\usage{
node_first_child_for_byte(x, byte)

node_first_named_child_for_byte(x, byte)

node_descendant_for_byte_range(x, start, end)

node_named_descendant_for_byte_range(x, start, end)

node_descendant_for_point_range(x, start_point, end_point)

node_named_descendant_for_point_range(x, start_point, end_point)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}

\item{byte,start,end}{0-indexed byte offsets.}

\item{start_point,end_point}{\code{tree_sitter_point} objects.}
}
\value{
A \code{tree_sitter_node}, or \code{NULL}.
}
\description{
Locate nodes by byte or point
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  root <- tree_root_node(text_parse("x <- 1\ny <- 2", treesitter.r::language()))
  node_text(node_first_named_child_for_byte(root, 7))
  node_text(node_descendant_for_byte_range(root, 7, 7))
  node_text(node_descendant_for_point_range(root, point(1, 0), point(1, 0)))
}
}
