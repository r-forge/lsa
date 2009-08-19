\name{dimcalc}
\alias{dimcalc}
\alias{dimcalc_share}
\alias{dimcalc_ndocs}
\alias{dimcalc_kaiser}
\alias{dimcalc_raw}
\alias{dimcalc_fraction}
\title{Dimensionality Calculation Routines (LSA)}
\description{
   Methods for choosing a `good' number of singular values for the dimensionality reduction in LSA.
}
\usage{
   dimcalc_share(share=0.5)
   dimcalc_ndocs(ndocs)
   dimcalc_kaiser()
   dimcalc_raw()
   dimcalc_fraction(frac=(1/50))
}
\arguments{
   \item{share}{Optional: a fraction of the sum of the selected singular values to the sum of all singular values (default: 0.5). Only needed by \code{dimcalc\_share}.}
   \item{frac}{Optional: a fraction of the number of the singular values to be used (default: 1/50th).}
   \item{ndocs}{Optional: the number of documents (only needed for \code{dimcalc\_ndocs()}).}
}
\details{
  In an LSA process, the diagonal matrix of the singular value decomposition is 
  usually reduced to a specific number of dimensions (also `factors' or `singular values').

  The functions \code{dimcalc\_share()}, \code{dimcalc\_ndocs()}, \code{dimcalc\_kaiser()}
  and also the redundant function \code{dimcalc\_raw()} offer methods to calculate a useful
  number of singular values (based on the distribution and values of the given sequence 
  of singular values).
  
  All of them are tightly coupled to the core LSA functions: they generates 
  a function to be executed by the calling (higher-level) 
  function \code{lsa()}. The output function contains only one parameter, 
  namely \code{s}, which is expected to be the sequence of singular values. 
  In \code{lsa()}, the code returned is executed, the mandatory 
  singular values are provided as a parameter within \code{lsa()}.
  
  The dimensionality calculation methods, however, can still be called directly
  by adding a second, separate parameter set: e.g.
  
  \code{dimcalc\_share(share=0.2)(mysingularvalues)}
  
  The method \code{dimcalc\_share()} finds the first position in the descending sequence of 
  singular values \code{s} where their sum (divided by the sum of all 
  values) meets or exceeds the specified share.
  
  The method \code{dimcalc\_ndocs()} calculates the first position in the descending sequence
  of singular values where their sum meets or exceeds the number of documents.
  
  The method \code{dimcalc\_kaiser()} calculates the number of singular values according to the 
  Kaiser-Criterium, i.e. from the descending order of values all values 
  with \code{s[n] > 1} will be taken. The number of dimensions is returned
  accordingly.
 
  The method \code{dimcalc_fraction()} returns the specified share of the
  number of singular values. Per default, 1/50th of the available values
  will be used and the determined number of singular values will be returned.
 
  The method \code{dimcalc\_raw()} return the maximum number of singular values (= the length 
  of \code{s}). It is here only for completeness.
  
}
\value{
  Returns a function that takes the singular values as a parameter to
  return the recommended number of dimensions. The expected parameter 
  of this function is 
  \item{s}{A sequence of singular values (as produced by the SVD). Only needed when calling the dimensionality calculation routines directly.}
}
\seealso{\code{\link{lsa}}}
\references{Wild, F., Stahl, C., Stermsek, G., Neumann, G., Penya, Y. (2005) \emph{Parameters Driving Effectiveness of Automated Essay Scoring with LSA}. In: Proceedings of the 9th CAA, pp.485-494, Loughborough }
\author{ Fridolin Wild \email{f.wild@open.ac.uk} }
\examples{

## create some data 
vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
matrix = cbind(vec1,vec2, vec3)
s = svd(matrix)$d

# standard share of 0.5
dimcalc_share()(s) 

# specific share of 0.9
dimcalc_share(share=0.9)(s) 

# meeting the number of documents (here: 3)
n = ncol(matrix)
dimcalc_ndocs(n)(s)

}
\keyword{algebra}
