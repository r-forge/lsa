\name{dimcalc}
\alias{dimcalc}
\alias{dimcalc_share}
\alias{dimcalc_ndocs}
\alias{dimcalc_kaiser}
\title{Dimensionality Calculation Routines (Matrices)}
\description{
   Calculates a (good) number of singular values for the dimensionality reduction in LSA.
}
\usage{
dimcalc(method=c("share","kaiser","ndocs","raw"), share=0.5, ndocs)
dimcalc_share(s, share=0.5)
dimcalc_ndocs(s, ndocs)
dimcalc_kaiser(s)
}
\arguments{
   \item{method}{Choose one method as described below.}
   \item{share}{Optional: a fraction [0;1] of the sum of the selected singular values to the sum of all singular values.}
   \item{ndocs}{Optional: the number of documents (only needed for method="ndocs").}
   \item{s}{A sequence of singular values (as produced by the svd). Only needed when calling the dimcal methods directly.}
}
\details{
  In an LSA-process, the diagonal matrix of the singular value decomposition is 
  usually reduced to a specific number of dimensions (also factors or singular values).
  The functions \code{dimcalc_share()} and \code{dimcalc_ndocs()} offer methods to calculate a
  useful number of singular values (based on the distribution and values of the
  given sequence of singular values).
  
  The function \code{dimcalc()} generates a function to be executed by
  the calling (higher-level) function (\code{createLSAspace()}). The
  generated function contains only one parameter, namely \code{s}, which
  is the sequence of singular values. In \code{createLSAspace()}, the
  code returned by \code{dimcalc()} is executed and the mandatory 
  singular values are provided as a parameter.

  Whenever you have to call one of the methods directly, do as follows:
     \code{dimcalc(method="share",share=0.2)(mysingularvalues)}
  
}
\value{
  \item{dimcalc_share}{finds the first position in the descending sequence of singular values s where their sum (divided by the sum of all values) meets or exceeds the specified share.}
  \item{dimcalc_ndocs}{calculates the first position in the descending sequence of singular values where their sum meets or exceeds the number of documents.}
  \item{dimcalc_kaiser}{calculates the number of singular values according to the Kaiser-Criterium, i.e. take all values with s[n] > 1).}
}
\references{Wild,Stahl,Stermsek,Neumann,Penya(2005)}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\examples{

## create some data 

vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
matrix = cbind(vec1,vec2, vec3)
s = svd(matrix)$d

## examples for the dimensionality calculation routines

reduced_s1 = dimcalc_share(s) # standard share of 0.5
reduced_s2 = dimcalc_share(s, share=0.3)
reduced_s3 = dimcalc_ndocs(s, 3)

}
\keyword{algebra}
\keyword{array}
