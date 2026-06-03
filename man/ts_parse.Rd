% tinyrox says don't edit this manually, but it can't stop you!
\name{ts_parse}
\alias{ts_parse}
\title{Parse source code into a syntax tree}
\usage{
ts_parse(parser, source, old_tree = NULL)
}
\arguments{
\item{parser}{A parser with a language set.}

\item{source}{A single character string of source code.}

\item{old_tree}{Optional previous tree for incremental parsing.}
}
\value{
A \code{ts_tree} object (list with \code{$ptr} and \code{$source}).
}
\description{
Parse source code into a syntax tree
}
