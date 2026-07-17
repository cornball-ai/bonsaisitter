% tinyrox says don't edit this manually, but it can't stop you!
\name{tree-accessors}
\alias{tree_text}
\alias{tree_language}
\title{Tree accessors}
\usage{
tree_text(x)

tree_language(x)
}
\arguments{
\item{x}{A `tree_sitter_tree`.}
}
\value{
`tree_text()` a string; `tree_language()` a language.
}
\description{
- `tree_text()` returns the text the tree was parsed with.
- `tree_language()` returns the tree's `tree_sitter_language`.
}
