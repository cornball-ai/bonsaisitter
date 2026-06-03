% tinyrox says don't edit this manually, but it can't stop you!
\name{ts_parser_set_language}
\alias{ts_parser_set_language}
\title{Set the language for a parser}
\usage{
ts_parser_set_language(parser, language)
}
\arguments{
\item{parser}{A parser created by \code{\link{ts_parser_new}}.}

\item{language}{A language object, e.g. from \code{\link{ts_language_r}}.}
}
\value{
\code{TRUE} on success, \code{FALSE} on ABI version mismatch.
}
\description{
Set the language for a parser
}
