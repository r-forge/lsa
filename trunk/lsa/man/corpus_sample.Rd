\name{corpus_sample}
\alias{corpus_sample}
\title{Corpus Sample (Matrices)}
\description{
  Generate a random sample of a document collection.
}
\usage{
corpus_sample( filelist, samplesize, index.return=FALSE)
}
\arguments{
   \item{filelist}{a vector containing (relative or absolute) filenames.}
   \item{samplesize}{the desired number of files to be returned.}
   \item{index.return}{if set to \code{TRUE}, the position of the sample files in filelist will be returned.}
}
\details{
   Creates a random sample of the size \code{samplesize} of
   the specified filelist.
}
\value{
  \item{x}{The random sample; a vector with filenames.}
  \item{x}{If index.return is set to \code{TRUE}, a list is returned; \code{x} contains
           the filenames and \code{ix} contains the position of the sample files in the
		   original filelist.}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{ \code{\link[Rstem]{textmatrix}}}
\examples{

# create some files
td = tempfile()
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td, "D1", sep="/") )
write( c("hamster", "mouse", "sushi"), file=paste(td, "D2", sep="/") )
write( c("dog", "monster", "monster"), file=paste(td, "D3", sep="/") )

s = corpus_sample(dir(td, full.names=TRUE), 2, index.return=TRUE)
textmatrix(s$x)

# clean up
unlink(td)

}
\keyword{array}
