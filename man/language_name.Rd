% tinyrox says don't edit this manually, but it can't stop you!
\name{language_name}
\alias{language_name}
\title{The name of a language}
\usage{
language_name(x)
}
\arguments{
\item{x}{A \code{tree_sitter_language}.}
}
\value{
A single string.
}
\description{
The name of a language
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  language_name(treesitter.r::language())
}
}
