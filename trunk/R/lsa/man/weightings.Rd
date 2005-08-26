\name{weightings}
\alias{lw_tf}
\alias{lw_logtf}
\alias{lw_bintf}
\alias{gw_normalisation}
\alias{gw_idf}
\alias{gw_gfidf}
\alias{entropy}
\alias{gw_entropy}
\title{Weighting Schemes (Matrices)}
\description{
  Calculates a weighted document-term-matrix according
  to the chosen local and/or global weighting scheme.
}
\note{
   When combining a local and a global weighting scheme to a given matrix m,
   
   dtm = lw(m) * gw(m)
   
   thereby,

   dtm is the given doc-term-matrix,
   
   lw(m) is one of the local weight functions \code{lw\_tf()}, \code{lw\_logtf()}, \code{lw\_bintf()}, and
   
   gw(m) is one of the global weight functions \code{gw\_normalisation()},
      \code{gw\_idf()}, \code{gw\_gfidf()}, \code{entropy()}, \code{gw\_entropy()}.
      
   The return value will be a matrix \code{dtm} of the size and format of the given input matrix \code{m}.
}
\usage{
lw_tf(m)
lw_logtf(m)
lw_bintf(m)
gw_normalisation(m)
gw_idf(m)
gw_gfidf(m)
entropy(m)
gw_entropy(m)
}
\arguments{
   \item{m}{a document-term-matrix.}
}
\details{
  This set of weighting schemes included the local weightings (lw) 
  raw, log, binary and the global weightings (gw) normalisation, two versions of the 
  inverse document frequency (idf) and the original as well as a slightly modified entropy.
}
\value{
  \item{lw_tf}{returns a completely unmodified n*m matrix (placebo function).}
  \item{lw_logtf}{returns the logarithmised n*m matrix. Every cell is applied log(m[i,j]+1).}
  \item{lw_bintf}{returns binary values of the n*m matrix. Every cell is assigned 1, iff the term-frequency does not equal 0.}
  \item{gw_normalisation}{returns a normalised n*m matrix. Every cell equals 1 divided by the square root of the document vector length.}
  \item{gw_idf}{returns the inverse document frequency in a n*m matrix. Every cell is one plus the logarithmus of the number of documents divided by the number of documents where the term appears.}
  \item{gw_gfidf}{returns the global frequency * idf. Every cell equals the sum of the frequencies of one term divided by the number of documents where the term shows up.}
  \item{entropy}{returns the entropy (as defined by Shannon).}
  \item{gw_entropy}{returns one plus entropy.}
}
\references{Dumais(1992), Nakov(2001), Shannon(1948)}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\examples{

## use the logarithmised term frequency as local weight and 
## the inverse document frequency as global weight.

vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
matrix = cbind(vec1,vec2, vec3)
dtm = lw_logtf(matrix)*gw_idf(matrix)

}
\keyword{algebra}
\keyword{array}
