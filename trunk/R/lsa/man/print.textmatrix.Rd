\name{print.textmatrix}
\alias{print.textmatrix}
\title{Print a textmatrix (Matrices)}
\description{
  Display a one screen short version of a textmatrix.
}
\usage{
print.textmatrix ( x, bag_lines, bag_cols, ... )
}
\arguments{
   \item{x}{A textmatrix.}
   \item{bag_lines}{The number of lines per bag.}
   \item{bag_cols}{The number of columns per bag.}
   \item{...}{}
}
\details{
    Document-term matrices are often very large and
    cannot be displayed completely on one screen. 
    Therefore, the textmatrix print method displays
    only clippings ('bags') from this matrix.
    
    Clippings are taken vertically and horizontally 
    from beginning, middle, and end of the matrix.
    \code{bag\_lines} lines (resp. \code{bag\_cols} columns) 
    are printed to the screen.
    
    To keep document titles from blowing up the display,
    a legend is introduced below, referencing the symbols
    used in the table.
    
}
\value{
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
print(m, bag_cols=5)

}
\keyword{textmatrix}
