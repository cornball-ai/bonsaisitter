% tinyrox says don't edit this manually, but it can't stop you!
\name{audit_translation}
\alias{audit_translation}
\title{Audit a code translation for drifted numeric constants}
\usage{
audit_translation(reference, port, lang = "r", normalize = TRUE)
}
\arguments{
\item{reference}{Character scalar of reference source.}

\item{port}{Character scalar of the port's source.}

\item{lang}{Language of both (\code{"r"}, \code{"python"}, \code{"cpp"},
\code{"go"}, \code{"rust"}, \code{"javascript"}). Pass a length-2 vector
to parse reference and port as different languages (e.g.
\code{c("python", "r")}).}

\item{normalize}{Logical; strip \code{L} suffixes and coerce so
\code{4.0 == 4L == 4}.}
}
\value{
A list: \code{literals_missing} (in reference, not port),
  \code{literals_extra} (in port, not reference), and the full
  \code{reference} / \code{port} extractions.
}
\description{
Compares a reference scope (e.g. the original Python or torch code) with
its port, reporting numeric literals present in one but not the other.
Parity tests prove the paths they exercise; this catches the drift they
do not -- wrong constants, dropped operations, unported branches. Call
names are returned too for eyeballing with a noise filter.
}
\details{
Numeric literals are normalized by default so \code{4.0}, \code{4L}, and
\code{4} compare equal.

}
\examples{
if (requireNamespace("treesitter.r", quietly = TRUE)) {
  audit_translation("clamp(x, 1e-10); y * 8", "pmax(x, 1e-10); y * 8")
}

}
