\name{pseudodtm}
\alias{query}
\title{Query (Textmatrix)}
\description{
  Create a query in the format of a given textmatrix. 
}
\usage{
query ( qtext, termlist, stemming=FALSE, language="german" )
}
\arguments{
   \item{termlist}{the termlist of the background latent-semantic space.}
   \item{language}{specifies language for the stemming / stop-word-removal.}
   \item{stemming}{boolean, specifies whether all terms will be reduced to their wordstems.}
   \item{qtext}{the query string, words are separated by blanks ' '.}
}
\details{
  Create queries in the format of a given textmatrix.
}
\value{
  \item{query}{returns the query vector (based on the given vocabulary) as matrix.}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{
\code{\link[Rstem]{wordStem}}, for more information see \code{\link{textmatrix}} 
}
\examples{

\dontshow{
td = tempdir()
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td,"/data_doc1.dt",sep="") )
write( c("hamster", "mouse", "sushi"), file=paste(td,"/data_doc2.dt",sep="") )
write( c("dog", "monster", "monster"), file=paste(td,"/data_doc3.dt",sep="") )
}

## demonstrate generation of a query
dtm = textmatrix(td)
query("monster", rownames(dtm))

\dontshow{
unlink(td, TRUE)
}

}
\keyword{algebra}
\keyword{array}
