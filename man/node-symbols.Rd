% tinyrox says don't edit this manually, but it can't stop you!
\name{node-symbols}
\alias{node_symbol}
\alias{node_grammar_symbol}
\alias{node_parse_state}
\alias{node_next_parse_state}
\title{Node symbols and parse states}
\usage{
node_symbol(x)

node_grammar_symbol(x)

node_parse_state(x)

node_next_parse_state(x)
}
\arguments{
\item{x}{A \code{tree_sitter_node}.}
}
\value{
A single double.
}
\description{
Node symbols and parse states
}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  node <- tree_root_node(text_parse("x <- 1", treesitter.r::language()))
  node_symbol(node)
  language_symbol_name(node_language(node), node_symbol(node))
  node_parse_state(node)
}
}
