% tinyrox says don't edit this manually, but it can't stop you!
\name{tree_included_ranges}
\alias{tree_included_ranges}
\title{The tree's included ranges}
\usage{
tree_included_ranges(x)
}
\arguments{
\item{x}{A \code{tree_sitter_tree}.}
}
\value{
A list of \code{tree_sitter_range} objects.
}
\description{
The tree's included ranges
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  tree <- text_parse("x <- 1", treesitter.r::language())
  tree_included_ranges(tree)
}
}
