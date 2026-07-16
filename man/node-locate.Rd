% tinyrox says don't edit this manually, but it can't stop you!
\name{node-locate}
\alias{node-locate}
\alias{node_first_named_child_for_byte}
\alias{node_descendant_for_byte_range}
\alias{node_named_descendant_for_byte_range}
\alias{node_descendant_for_point_range}
\alias{node_named_descendant_for_point_range}
\title{Locate nodes by byte or point}
\usage{
node-locate(x, byte)

node_first_named_child_for_byte(x, byte)

node_descendant_for_byte_range(x, start, end)

node_named_descendant_for_byte_range(x, start, end)

node_descendant_for_point_range(x, start_point, end_point)

node_named_descendant_for_point_range(x, start_point, end_point)
}
\arguments{
\item{x}{A `tree_sitter_node`.}

\item{byte,start,end}{0-indexed byte offsets.}

\item{start_point,end_point}{`tree_sitter_point` objects.}
}
\value{
A `tree_sitter_node`, or `NULL`.
}
\description{
Locate nodes by byte or point
}
