% tinyrox says don't edit this manually, but it can't stop you!
\name{language-fields}
\alias{language-fields}
\alias{language_field_name_for_id}
\alias{language_field_id_for_name}
\title{Language fields}
\usage{
language-fields(x)

language_field_name_for_id(x, id)

language_field_id_for_name(x, name)
}
\arguments{
\item{x}{A `tree_sitter_language`.}

\item{id}{A field id.}

\item{name}{A field name.}
}
\value{
Counts and ids as a double; names as a string.
}
\description{
- `language_field_count()` is the number of distinct fields.
- `language_field_name_for_id()` maps a field id to its name.
- `language_field_id_for_name()` maps a field name to its id.
}
