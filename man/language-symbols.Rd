% tinyrox says don't edit this manually, but it can't stop you!
\name{language-symbols}
\alias{language_symbol_count}
\alias{language_symbol_name}
\alias{language_symbol_for_name}
\title{Language symbols}
\usage{
language_symbol_count(x)

language_symbol_name(x, symbol)

language_symbol_for_name(x, name, named = TRUE)
}
\arguments{
\item{x}{A `tree_sitter_language`.}

\item{symbol}{A symbol id.}

\item{name}{A node type name.}

\item{named}{Whether to look up the named or anonymous variant.}
}
\value{
Counts and ids as a double; names as a string.
}
\description{
- `language_symbol_count()` is the number of distinct node types.
- `language_symbol_name()` maps a symbol id to its name.
- `language_symbol_for_name()` maps a name to its symbol id.
}
