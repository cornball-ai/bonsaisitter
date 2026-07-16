% tinyrox says don't edit this manually, but it can't stop you!
\name{query}
\alias{query}
\title{Compile a tree-sitter query}
\usage{
query(language, source)
}
\arguments{
\item{language}{A `tree_sitter_language`.}

\item{source}{A single string of query source (tree-sitter S-expression
pattern syntax).}
}
\value{
A `tree_sitter_query`.
}
\description{
Compile a tree-sitter query
}
