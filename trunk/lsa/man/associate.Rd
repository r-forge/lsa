\name{associate}
\alias{associate}
\title{Find close terms in a textmatrix}
\description{
   Returns those terms above a threshold
   close to the input term, sorted in descending 
   order of their closeness. Alternatively,
   all terms and their closeness value can
   be returned sorted descending.
}
\usage{
associate(textmatrix, term, measure = "cosine", threshold = 0.7)
}
\arguments{
   \item{textmatrix}{A document-term matrix.}
   \item{term}{The stimulus 'word'.}
   \item{measure}{The closeness measure to choose (Pearson, Spearman, Cosine)}
   \item{threshold}{Terms being closer than this threshold are going to be returned.}
}
\details{

   Internally, a complete term-to-term similarity table
   is calculated, denoting the closeness (calculated with 
   the specified measure) in its cells. All
   terms being close above this specified threshold are returned,
   sorted by their closeness value. Select a threshold of 0 to
   get all terms. 

}
\value{
  \item{termlist}{A named vector of closeness values (terms as labels, sorted in descending order).}
}
\author{ Fridolin Wild \email{f.wild@open.ac.uk} }
\seealso{ \code{\link{textmatrix}} }
\examples{

# create some files
td = tempfile()
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td, "D1", sep="/"))
write( c("hamster", "mouse", "sushi"), file=paste(td, "D2", sep="/"))
write( c("dog", "monster", "monster"), file=paste(td, "D3", sep="/"))
write( c("dog", "mouse", "dog"), file=paste(td, "D4", sep="/"))

# create matrices
myMatrix = textmatrix(td, minWordLength=1)
myLSAspace = lsa(myMatrix, dims=dimcalc_share()) 
myNewMatrix = as.textmatrix(myLSAspace) 

# calc associations for mouse
associate(myNewMatrix, "mouse")

# clean up
unlink(td, recursive=TRUE)

}
\keyword{algebra}
