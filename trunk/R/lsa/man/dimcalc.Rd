\name{dimcalc}
\alias{dimcalc}
\alias{dimcalc_share}
\alias{dimcalc_ndocs}
\alias{dimcalc_kaiser}
\title{Dimensionality Calculation Routines (LSA)}
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
   \item{method}{Choose one calculation method as described below.}
   \item{share}{Optional: a fraction [0;1] of the sum of the selected singular values to the sum of all singular values (default value = 0.5).}
   \item{ndocs}{Optional: the number of documents (only needed for method="ndocs").}
   \item{s}{A sequence of singular values (as produced by the svd). Only needed when calling the dimcalc() directly.}
}
\details{
  In an LSA process, the diagonal matrix of the singular value decomposition is 
  usually reduced to a specific number of dimensions (also 'factors' or 'singular values').

  The functions \code{dimcalc_share()}, \code{dimcalc_ndocs()} and \code{dimcalc_kaiser()} offer
  methods to calculate a useful number of singular values (based on the distribution and 
  values of the given sequence of singular values).
  
  Unlike these, the function \code{dimcalc()} is tightly coupled to the
  core lsa functions: it generates a function to be executed 
  by the calling (higher-level) function \code{createLSAspace()}. The
  output function contains only one parameter, namely \code{s}, which
  is expected to be the sequence of singular values. In \code{createLSAspace()}, 
  the code returned by \code{dimcalc()} is executed, the mandatory 
  singular values are provided as a parameter within \code{createLSAspace()}.
  
  The dimensionality calculation methods, however, can still be called directly
  with \code{dimcalc()} by adding a second, separate parameter set:
  
  \code{dimcalc(method="share",share=0.2)(mysingularvalues)}
  
  The stand-alone methods might be removed in future releases 
  of this package.
  
  The method 'share' finds the first position in the descending sequence of 
  singular values \code{s} where their sum (divided by the sum of all 
  values) meets or exceeds the specified share.
  
  The method 'ndocs' calculates the first position in the descending sequence
  of singular values where their sum meets or exceeds the number of documents.
  
  The method 'kaiser' calculates the number of singular values according to the 
  Kaiser-Criterium, i.e. from the descending order of values all values 
  with \code{s[n] > 1} will be taken. The number of dimensions is returned
  accordingly.
  
  The method 'raw' return the maximum number of singular values (= the length of \code{s}). 
  It is here only for completeness.
  
}
\value{
  Returns a function that takes the singular values as a parameter to
  return the recommended number of dimensions.
}
\seealso{\code{\link{createLSAspace}}}
\references{Wild, F., Stahl, C., Stermsek, G., Neumann, G., Penya, Y. (2005) \emph{Parameters Driving Effectiveness of Automated Essay Scoring with LSA}. In: Proceedings of the 9th CAA, pp.485-494, Loughborough }
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\examples{

## create some data 
vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
matrix = cbind(vec1,vec2, vec3)
s = svd(matrix)$d

# standard share of 0.5
dimcalc(method="share")(s) 

# specific share of 0.9
dimcalc(method="share", share=0.9)(s) 

# meeting the number of documents (here: 3)
n = ncol(matrix)
dimcalc(method="ndocs", ndocs=n)(s)

}
\keyword{latent semantic analysis}
