% tinyrox says don't edit this manually, but it can't stop you!
\name{text_parse}
\alias{text_parse}
\title{Parse text in one step}
\usage{
text_parse(x, language)
}
\arguments{
\item{x}{A single string to parse.}

\item{language}{A `tree_sitter_language`.}
}
\value{
A `tree_sitter_tree`.
}
\description{
`text_parse()` is a convenience wrapper that builds a parser for `language`
and parses `x` with it, returning the tree directly.
}
