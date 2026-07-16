% tinyrox says don't edit this manually, but it can't stop you!
\name{parser}
\alias{parser}
\title{Create a parser}
\usage{
parser(language)
}
\arguments{
\item{language}{A `tree_sitter_language`, e.g. from a grammar package like
`treesitter.r::language()`.}
}
\value{
A `tree_sitter_parser`.
}
\description{
`parser()` constructs a parser from a `tree_sitter_language`. Use
[parser_parse()] to parse text with it.
}
