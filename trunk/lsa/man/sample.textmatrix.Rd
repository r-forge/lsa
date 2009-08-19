\name{sample.textmatrix}
\alias{sample.textmatrix}
\title{Create a random sample of files}
\description{
    Creates a subset of the documents
    of a corpus to help reduce a corpus in size
    through random sampling.
}
\usage{
sample.textmatrix(textmatrix, samplesize, index.return=FALSE)
}
\arguments{
   \item{textmatrix}{A document-term matrix.}
   \item{samplesize}{Desired number of files}
   \item{index.return}{if set to \code{true}, the positions of the subset in the original column vectors will be returned as well.}
}
\details{

   Often a corpus is so big that it cannot be processed
   in memory. One technique to reduce the size is to
   select a subset of the documents randomly, assuming
   that through the random selection the nature of
   the term sets and distributions will not be changed. 

}
\value{
  \item{filelist}{a list of filenames of the documents in the corpus.). }
  \item{ix}{If index.return is set to \code{true}, a list is returned; \code{x} contains
           the filenames and \code{ix} contains the position of the sample files in the
                   original filelist.}

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

sample(myMatrix, 2)

# clean up
unlink(td, recursive=TRUE)

}
\keyword{algebra}
