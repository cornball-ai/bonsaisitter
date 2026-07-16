% tinyrox says don't edit this manually, but it can't stop you!
\name{tree-cursor}
\alias{tree-cursor}
\alias{node_walk}
\title{Walk a tree or node with a cursor}
\usage{
tree-cursor(x)

node_walk(node)
}
\arguments{
\item{x}{A `tree_sitter_tree`.}

\item{node}{A `tree_sitter_node`.}
}
\value{
A `tree_sitter_tree_cursor`.
}
\description{
`tree_walk()` and `node_walk()` create a `tree_sitter_tree_cursor`, a mutable
cursor for efficient traversal. Navigate with its methods:
`cursor$goto_first_child()`, `cursor$goto_next_sibling()`,
`cursor$goto_parent()` (each returns `TRUE`/`FALSE`), and read state with
`cursor$node()`, `cursor$field_name()`, and `cursor$depth()`.
}
