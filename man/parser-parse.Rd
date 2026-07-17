% tinyrox says don't edit this manually, but it can't stop you!
\name{parser-parse}
\alias{parser_parse}
\alias{parser_reparse}
\title{Parse or reparse text}
\usage{
parser_parse(x, text, ...)

parser_reparse(x, text, tree, start_byte, start_point, old_end_byte,
               old_end_point, new_end_byte, new_end_point)
}
\arguments{
\item{x}{A `tree_sitter_parser`.}

\item{text}{A single string to parse.}

\item{...}{Unused.}

\item{tree}{The original `tree_sitter_tree` from `parser_parse()`.}

\item{start_byte,old_end_byte,new_end_byte}{Edit byte offsets.}

\item{start_point,old_end_point,new_end_point}{Edit `tree_sitter_point`s.}
}
\value{
A `tree_sitter_tree`.
}
\description{
- `parser_parse()` parses `text` and returns a `tree_sitter_tree`.
- `parser_reparse()` performs an incremental reparse of a slightly edited
  `text`, reusing the old `tree`. All bytes and points are 0-indexed.
}
