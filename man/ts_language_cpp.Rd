% tinyrox says don't edit this manually, but it can't stop you!
\name{ts_language_cpp}
\alias{ts_language_cpp}
\title{Return the tree-sitter C++ language grammar}
\usage{
ts_language_cpp()
}
\value{
An external pointer of class \code{"ts_language"}.
}
\description{
Returns an external pointer to the bundled C++ language grammar
(tree-sitter-cpp v0.23.4) for use with
\code{\link{ts_parser_set_language}}. Handy for parsing C/C++ headers,
for example to scaffold R bindings from a library's public API.
}
