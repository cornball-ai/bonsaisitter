% tinyrox says don't edit this manually, but it can't stop you!
\name{language-states}
\alias{language_state_count}
\alias{language_next_state}
\title{Language parse states}
\usage{
language_state_count(x)

language_next_state(x, state, symbol)
}
\arguments{
\item{x}{A \code{tree_sitter_language}.}

\item{state}{A parse state id.}

\item{symbol}{A symbol id.}
}
\value{
A single double.
}
\description{
Language parse states
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  lang <- treesitter.r::language()
  language_state_count(lang)
  node <- tree_root_node(text_parse("x <- 1", lang))
  language_next_state(lang, node_parse_state(node), node_grammar_symbol(node))
}
}
