\name{cosine}
\alias{cosine}
\title{Cosine Measure (Matrices)}
\description{
  Calculates the cosine measure between two vectors or between all column vectors of a matrix.
}
\usage{
cosine(x, y = NULL)
}
\arguments{
   \item{x}{A vector or a matrix (e.g. a document-term matrix).}
   \item{y}{Optional: a vector with compatible dimensions to 'x'. If 'NULL', all column vectors of x are correlated.}
}
\details{
  \code{cosine()} calculates a similarity matrix between all column
  vectors of a matrix x. This matrix might be a document-term
  matrix, so columns would be expected to be documents and
  rows to be terms.
  
  When executed on two vectors \code{x} and \code{y}, 
  \code{cosine()} calculates the cosine similarity between them.
  
  Be reminded that the cosine measure is nearly identical
  with the pearson correlation coefficient \code{cor(method="pearson")}
  (besides a constant factor). For an investigation on
  the differences in the context of textmining see
  (Leydesdorff, 2005).

}
\value{
  Returns a n*n similarity matrix of cosine values, comparing all 
  n column vectors against each other. Executed on two vectors, their 
  cosine similarity value is returned.
}
\seealso{\code{\link[stats]{cor}}}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\references{Leydesdorff, L. (2005) \emph{Similarity Measures, Author Cocitation Analysis,and Information Theory}. In: JASIST 56(7), pp.769-772.}
\examples{

## the cosinus measure between two vectors

vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
cosine(vec1,vec2) 

% =>
%    0.2357023

## the cosine measure for all document vectors of a matrix

vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
matrix = cbind(vec1,vec2, vec3)
cosine(matrix)

% =>
%           vec1      vec2      vec3
% vec1 1.0000000 0.2357023 0.2886751
% vec2 0.2357023 1.0000000 0.4082483
% vec3 0.2886751 0.4082483 1.0000000

}
\keyword{Statistics}
