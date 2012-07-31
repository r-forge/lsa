\name{alnumx}
\docType{data}
\alias{alnumx}
\title{Regular expression for removal of non-alphanumeric characters (saving special characters)}
\description{
This character string contains a regular expression for use in \code{gsub} deployed in \code{textvector} that identifies all alphanumeric characters (including language specific special characters not included in \code{[:alnum:]}, currently only the ones found in German and Polish.
You can use this expression by loading it with \code{data(alnumx)}.

}
\usage{
   data(alnumx)
}
\author{ Fridolin Wild \email{f.wild@open.ac.uk}}
\format{Vector of type character.}
\keyword{datasets}
