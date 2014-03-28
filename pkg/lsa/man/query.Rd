\name{query}
\alias{query}
\title{Query (Matrices)}
\description{
  Create a query in the format of a given textmatrix. 
}
\usage{
query ( qtext, termlist, stemming=FALSE, language="german" )
}
\arguments{
   \item{termlist}{the termlist of the background latent-semantic space.}
   \item{language}{specifies a language for stemming / stop-word-removal.}
   \item{stemming}{boolean, specifies whether all terms will be reduced to their wordstems.}
   \item{qtext}{the query string, words are separated by blanks.}
}
\details{
  Create queries, i.e., an additional term vector to be used for query-to-document
  comparisons, in the format of a given textmatrix.
}
\value{
  \item{query}{returns the query vector (based on the given vocabulary) as matrix.}
}
\author{ Fridolin Wild \email{f.wild@open.ac.uk} }
\seealso{
\code{\link[SnowballC]{wordStem}}, \code{\link{textmatrix}} 
}
\examples{

# prepare some files
td = tempfile()
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td,"D1", sep="/") )
write( c("hamster", "mouse", "sushi"), file=paste(td,"D2", sep="/") )
write( c("dog", "monster", "monster"), file=paste(td,"D3", sep="/") )

# demonstrate generation of a query
dtm = textmatrix(td)
query("monster", rownames(dtm))
query("monster dog", rownames(dtm))

# clean up
unlink(td, TRUE)

}
\keyword{array}
