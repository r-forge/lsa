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
  Calculates a weighted document-term matrix according
  to the chosen local and/or global weighting scheme.
}
\note{
   When combining a local and a global weighting scheme to a given textmatrix m,
   
   \code{dtm = lw(m) * gw(m)}
   
   thereby,

   dtm is the given document-term matrix,
   
   lw(m) is one of the local weight functions \code{lw\_tf()}, \code{lw\_logtf()}, \code{lw\_bintf()}, and
   
   gw(m) is one of the global weight functions \code{gw\_normalisation()},
      \code{gw\_idf()}, \code{gw\_gfidf()}, \code{entropy()}, \code{gw\_entropy()}.
      
   The return value will be a textmatrix of the size and format of the given input matrix \code{m}.
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
   \item{m}{a document-term matrix.}
}
\details{
  This set of weighting schemes included the local weightings (lw) 
  raw, log, binary and the global weightings (gw) normalisation, two versions of the 
  inverse document frequency (idf), and entropy in both the original Shannon as well as 
  in a slightly modified version.
}
\value{
  \item{lw_tf}{returns a completely unmodified n*m matrix (placebo function).}
  \item{lw_logtf}{returns the logarithmised n*m matrix. log(m[i,j]+1) is applied on every cell.}
  \item{lw_bintf}{returns binary values of the n*m matrix. Every cell is assigned 1, iff the term frequency is not equal to 0.}
  \item{gw_normalisation}{returns a normalised n*m matrix. Every cell equals 1 divided by the square root of the document vector length.}
  \item{gw_idf}{returns the inverse document frequency in a n*m matrix. Every cell is 1 plus the logarithmus of the number of documents divided by the number of documents where the term appears.}
  \item{gw_gfidf}{returns the global frequency multiplied with idf. Every cell equals the sum of the frequencies of one term divided by the number of documents where the term shows up.}
  \item{entropy}{returns the entropy (as defined by Shannon).}
  \item{gw_entropy}{returns one plus entropy.}
}
\references{

Dumais, S. (1992) \emph{Enhancing Performance in Latent Semantic Indexing (LSI) Retrieval}. Technical Report, Bellcore.

Nakov, P., Popova, A., and Mateev, P. (2001) \emph{Weight functions impact on LSA performance}. In: Recent Advances in Natural language processing – RANLP’2001. Tzigov Chark, Bulgaria, pp. 187--193.

Shannon, C. (1948) \emph{A Mathematical Theory of Communication}. In: The Bell System Technical Journal 27 (July), pp. 379–423.

}
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
