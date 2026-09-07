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
\item{x}{A \code{tree_sitter_tree}.}
}
\value{
\code{tree_text()} a string; \code{tree_language()} a language.
}
\description{
- \code{tree_text()} returns the text the tree was parsed with.
- \code{tree_language()} returns the tree's \code{tree_sitter_language}.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  tree_text(tree)
  language_name(tree_language(tree))
}
}
