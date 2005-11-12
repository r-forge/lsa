\name{meanmax}
\alias{mean_max}
\title{Mean and Maximum Correlation (Matrices)}
\description{
  Calculate the mean average and the maximum (best) correlation of
  documents with a given set of documents.
}
\usage{
mean_max ( corPD, best )
}
\arguments{
   \item{corPD}{correlation table (comparing every document with every document).}
   \item{best}{sequence of the names of the best entries in the correlation table.}
}
\details{

}
\value{
  \item{mean_max$mean}{returns for every document the average correlation with the \bold{best} documents.}
  \item{mean_max$max}{returns for every document the highest correlation among the \bold{best} documents.}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{\code{\link[stats]{cor}}}
\examples{
   
   vec1 = c( 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
   vec2 = c( 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0 )
   vec3 = c( 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0 )
   matrix = cbind(vec1,vec2, vec3)
   colnames(matrix) = c("test.txt", "bla.txt", "bla2.txt")

   mean_max( cor(matrix), c("bla.txt","bla2.txt") )
}
\keyword{algebra}
\keyword{array}
