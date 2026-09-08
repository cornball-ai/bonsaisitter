% tinyrox says don't edit this manually, but it can't stop you!
\name{parser-adjust}
\alias{parser_set_language}
\alias{parser_set_timeout}
\alias{parser_set_included_ranges}
\title{Adjust a parser}
\usage{
parser_set_language(x, language)

parser_set_timeout(x, timeout)

parser_set_included_ranges(x, included_ranges)
}
\arguments{
\item{x}{A \code{tree_sitter_parser}.}

\item{language}{A \code{tree_sitter_language}.}

\item{timeout}{A single whole number of microseconds.}

\item{included_ranges}{A list of \code{tree_sitter_range} objects.}
}
\value{
A new \code{tree_sitter_parser}.
}
\description{
Each returns a new parser with one setting changed.
- \code{parser_set_language()} sets the language.
- \code{parser_set_timeout()} sets a parse timeout in microseconds (0 clears it).
- \code{parser_set_included_ranges()} restricts parsing to a list of \code{\link{range}}s
  (an empty list clears the restriction).
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  lang <- treesitter.r::language()
  p <- parser_set_timeout(parser(lang), 1e6)
  p <- parser_set_language(p, lang)
  first_line <- range(0, point(0, 0), 6, point(0, 6))
  p <- parser_set_included_ranges(p, list(first_line))
  node_text(tree_root_node(parser_parse(p, "x <- 1\ny <- 2")))
}
}
