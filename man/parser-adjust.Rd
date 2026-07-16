% tinyrox says don't edit this manually, but it can't stop you!
\name{parser-adjust}
\alias{parser-adjust}
\alias{parser_set_timeout}
\alias{parser_set_included_ranges}
\title{Adjust a parser}
\usage{
parser-adjust(x, language)

parser_set_timeout(x, timeout)

parser_set_included_ranges(x, included_ranges)
}
\arguments{
\item{x}{A `tree_sitter_parser`.}

\item{language}{A `tree_sitter_language`.}

\item{timeout}{A single whole number of microseconds.}

\item{included_ranges}{A list of `tree_sitter_range` objects.}
}
\value{
A new `tree_sitter_parser`.
}
\description{
Each returns a new parser with one setting changed.
- `parser_set_language()` sets the language.
- `parser_set_timeout()` sets a parse timeout in microseconds (0 clears it).
- `parser_set_included_ranges()` restricts parsing to a list of [range()]s
  (an empty list clears the restriction).
}
