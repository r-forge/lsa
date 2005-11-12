\name{summary.textmatrix}
\alias{summary.textmatrix}
\title{Summary of a textmatrix (Matrices)}
\description{
  Return a summary with some statistical infos about a given textmatrix.
}
\usage{
summary.textmatrix ( object, ... )
}
\arguments{
   \item{object}{A textmatrix.}
   \item{...}{}
}
\details{
Returns some statistical infos about the textmatrix \code{x}:
number of terms, number of documents, maximum length of a term, 
number of values not 0, number of terms containing strange
characters.
}
\value{
   \item{matrix}{Returns a matrix.}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{ \code{\link{textmatrix}} }
\examples{

# fake a matrix
m = matrix(ncol=800, nrow=400)
m[1:length(m)] = 1:length(m)
colnames(m) = paste("D",1:ncol(m),sep="")
rownames(m) = paste("W",1:nrow(m),sep="")
class(m) = "textmatrix"

# show a short form of the matrix
summary(m)

}
\keyword{textmatrix}
