% tinyrox says don't edit this manually, but it can't stop you!
\name{parser-parse}
\alias{parser_parse}
\alias{parser_reparse}
\title{Parse or reparse text}
\usage{
parser_parse(x, text, ...)

parser_reparse(
  x,
  text,
  tree,
  start_byte,
  start_point,
  old_end_byte,
  old_end_point,
  new_end_byte,
  new_end_point
)
}
\arguments{
\item{x}{A \code{tree_sitter_parser}.}

\item{text}{A single string to parse.}

\item{...}{Unused.}

\item{tree}{The original \code{tree_sitter_tree} from \code{parser_parse()}.}

\item{start_byte,old_end_byte,new_end_byte}{Edit byte offsets.}

\item{start_point,old_end_point,new_end_point}{Edit \code{tree_sitter_point}s.}
}
\value{
A \code{tree_sitter_tree}.
}
\description{
- \code{parser_parse()} parses \code{text} and returns a \code{tree_sitter_tree}.
- \code{parser_reparse()} performs an incremental reparse of a slightly edited
  \code{text}, reusing the old \code{tree}. All bytes and points are 0-indexed.
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  p <- parser(treesitter.r::language())
  tree <- parser_parse(p, "x <- 1")
  # Replace the "1" at byte 5 with "42", then reparse incrementally.
  tree2 <- parser_reparse(p, "x <- 42", tree, 5, point(0, 5), 6, point(0, 6),
                          7, point(0, 7))
  node_text(tree_root_node(tree2))
}
}
