\name{lsa}
\alias{lsa}
\title{Create a vector space with Latent Semantic Analysis (LSA)}
\description{
   Calculates a latent semantic space from a given document-term matrix.
}
\usage{
   lsa( x, dims=dimcalc_share() )
}
\arguments{
   \item{x}{a document-term matrix (recommeded to be of class textmatrix), containing documents in 
   colums, terms in rows and occurrence frequencies in the cells.}
   \item{dims}{either the number of dimensions or a configuring function.}
}
\details{
  
LSA combines the classical vector space model --- well known in 
textmining --- with a Singular Value Decomposition (SVD), a two-mode 
factor analysis. Thereby, bag-of-words representations of texts can 
be mapped into a modified vector space that is assumed to reflect 
semantic structure.

With \code{lsa()} a new latent semantic space can
be constructed over a given document-term matrix. To ease
comparisons of terms and documents with common
correlation measures, the space can be converted into
a textmatrix of the same format as \code{y} 
by calling \code{as.textmatrix()}.

To add more documents or queries to this latent semantic
space in order to keep them from influencing the original 
factor distribution (i.e., the latent semantic structure calculated
from a primary text corpus), they can be `folded-in' later on 
(with the function \code{fold_in()}).

Background information (see also Deerwester et al., 1990): 

A document-term matrix \code{M} is constructed 
with \code{textmatrix()} from a given text base of \code{n} documents 
containing \code{m} terms.
This matrix \code{M} of the size \code{m*n} is then decomposed via a
singular value decomposition into: term vector matrix \code{T} (constituting 
left singular vectors), the document vector matrix \code{D} (constituting 
right singular vectors) being both orthonormal, and the diagonal matrix 
\code{S} (constituting singular values). 

\begin{center}
\eqn{M = TSD^T}
\end{center}

These matrices are then reduced to the given number of dimensions \eqn{k=dims}
to result into truncated matrices \eqn{T_{k}}, \eqn{S_{k}} and \eqn{D_{k}} --- the
latent semantic space. 

\begin{center}
\eqn{M_k = \sum\limits_{i=1}^k t_i \cdot s_i \cdot d_i }
\end{center}

If these matrices \eqn{T_k, S_k, D_k} were multiplied, they would give a new
matrix \eqn{M_k} (of the same format as \eqn{M}, i.e., rows are the
same terms, columns are the same documents), which is the least-squares best 
fit approximation of \eqn{M} with \eqn{k} singular values.

In the case of folding-in, i.e., multiplying new documents into a given
latent semantic space, the matrices \eqn{T_k} and \eqn{S_k} remain unchanged
and an additional \eqn{D_k} is created (without replacing the old one).
All three are multiplied together to return a (new and appendable)
document-term matrix \eqn{\hat{M}} in the term-order of \eqn{M}.

}
\value{
  \item{LSAspace}{a list with components (\eqn{T_k, S_k, D_k}), representing the latent semantic space.}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{ 
  \code{\link{as.textmatrix}}, \code{\link{fold_in}}, \code{\link{textmatrix}}, \code{\link{gw_idf}}, \code{\link{dimcalc_share}}
}
\references{
Deerwester, S., Dumais, S., Furnas, G., Landauer, T., and Harshman, R. (1990) \emph{Indexing by Latent Semantic Analysis}. In: Journal of the American Society for Information Science 41(6), pp. 391--407.

Landauer, T., Foltz, P., and Laham, D. (1998) \emph{Introduction to Latent Semantic Analysis}. In: Discourse Processes 25, pp. 259--284.
}
\examples{

# create some files
td = tempfile()
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td, "D1", sep="/") )
write( c("ham", "mouse", "sushi"), file=paste(td, "D2", sep="/") )
write( c("dog", "pet", "pet"), file=paste(td, "D3", sep="/") )

# LSA
data(stopwords_en)
myMatrix = textmatrix(td, stopwords=stopwords_en)
myMatrix = lw_logtf(myMatrix) * gw_idf(myMatrix)
myLSAspace = lsa(myMatrix, dims=dimcalc_share())
as.textmatrix(myLSAspace)

# clean up
unlink(td, recursive=TRUE)

}
\keyword{algebra}
