\name{cosine}
\alias{cosine}
\alias{cosvecs}
\title{Cosine Measure (Matrices)}
\description{
  \code{cosine} calculates the cosine measure between all document-vectors of a given document-term-matrix.
  \code{cosvecs} calculates the cosine measure between two given vectors.
}
\usage{
cosine(m)
cosvecs(v1,v2)
}
\arguments{
   \item{v1}{the first document vector.}
   \item{v2}{the first document vector.}
   \item{m}{a document-term-matrix.}
}
\details{
  \code{cosvecs()} is a support function for \code{cosine()} but may
  be called directly to calculate the similarity between
  two single document vectors.
  
  \code{cosine()} expects the columns of the matrix to be the
  documents and the rows to be the terms.
  
  Be reminded that \code{cosine()} is nearly identical
  with the pearson correlation coefficient \code{cor()}.

}
\value{
  \code{cosine()} returns a n*n matrix of similarity values
  for each of the n documents against each other of the
  given doc-term-matrix.
}
\seealso{\code{\link[stats]{cor}}}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\examples{

## the cosinus measure between two vectors
vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
cosvecs(vec1,vec2) 

% should give:
%    0.2357023

## the cosine measure for all document vectors of a matrix
vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
matrix = cbind(vec1,vec2, vec3)
cosine(matrix)

% should give:
%           vec1      vec2      vec3
% vec1 1.0000000 0.2357023 0.2886751
% vec2 0.2357023 1.0000000 0.4082483
% vec3 0.2886751 0.4082483 1.0000000

}
\keyword{algebra}
\keyword{array}
