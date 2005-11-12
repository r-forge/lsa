\name{createLSAspace}
\alias{createLSAspace}
\title{Create a vector space with Latent Semantic Analysis (LSA)}
\description{
   Calculates a latent semantic space from a given document-term matrix.
}
\usage{
   createLSAspace( x, dims=dimcalc(method="share") )
}
\arguments{
   \item{x}{a document-term matrix (recommeded to be of class 'textmatrix'), containing documents in 
   colums, terms in rows and occurrence frequencies in the cells.}
   \item{dims}{either the number of dimensions or the configuring function 'dimcalc()'.}
}
\details{
  
LSA combines the classical vector space model -- well known in 
textmining -- with a singular value decomposition (SVD), a two-mode 
factor analysis. Thereby, bag-of-words representations of texts can 
be mapped into a modified vector space that is assumed to reflect 
semantic structure.

With \code{createLSAspace()} a new latent semantic space can
be constructed over a given document-term matrix. To ease
comparisons of terms and documents with common
correlation measures, the space can be converted into
a document-term matrix of the same format as \code{y} 
by calling \code{showLSAspace()}.

To add more documents or queries to this latent semantic
space in order to keep them from influencing the original 
factor distribution (=the latent semantic structure calculated
from a primary text corpus), they can be 'folded-in' later on 
with the function \code{foldinLSAspace()}.

Background information (see also Deerwester et al., 1990): 

A document-term matrix \code{M} is constructed 
with \code{textmatrix()} from a given text base of \code{n} documents 
containing \code{m} terms.
This matrix \code{M} of the size \code{m*n} is then decomposed via a
singular value decomposition into: term vector matrix \code{T} (constituting 
left singular vectors), the document vector matrix \code{D} (constituting 
right singular vectors) being both orthonormal, and the diagonal matrix 
\code{S} (constituting singular values). 

\code{LSAspace = svd(M)}

\code{T = LSAspace$u}

\code{S = LSAspace$d}

\code{D = LSAspace$v}

These matrices are then reduced to the given number of dimensions \code{k=dims}
to result into truncated matrices \code{Tk}, \code{Sk} and \code{Dk} -- the
latent semantic space. 

\code{Tk = T[,1:k]}

\code{Sk = S[1:k]}

\code{Dk = D[,1:k]}

If these matrices \code{Tk, Sk, Dk} were multiplied, they would give a new
matrix \code{Mk} (of the same format as \code{M}, i.e. rows are the
same terms, columns are the same documents), which is the least-squares best 
fit approximation of \code{M} with \code{k} singular values.

In the case of folding-in, i.e. multiplying new documents into a given
latent semantic space, the matrices \code{Tk} and \code{Sk} remain unchanged
and an additional \code{Dk} is created (without replacing the old one).
All three are multiplied together to return a (new and appendable)
document-term matrix \code{Mnew} in the term-order of \code{M}.

}
\value{
  \item{LSAspace}{a latent semantic space (a list containing Tk, Sk, Dk).}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{ 
  \code{\link{showLSAspace}}, \code{\link{foldinLSAspace}}, 
  Creating a document-term matrix: \code{\link{textmatrix}}, 
  applying weighting schemes: \code{\link{gw_idf}} 
}
\references{
Deerwester, S., Dumais, S., Furnas, G., Landauer, T., and Harshman, R. (1990) \emph{Indexing by Latent Semantic Analysis}. In: Journal of the American Society for Information Science 41(6), pp. 391--407.

Landauer, T., Foltz, P., and Laham, D. (1998) \emph{Introduction to Latent Semantic Analysis}. In: Discourse Processes 25, pp. 259--284.
}
\examples{

# create some files
td = tempdir()
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td, "data_doc1.dt", sep="/")
write( c("hamster", "mouse", "sushi"), file=paste(td, "data_doc2.dt", sep="/")
write( c("dog", "monster", "monster"), file=paste(td, "data_doc3.dt", sep="/")

# LSA
data(stopwords_en)
myMatrix = textmatrix(td, stopwords=stopwords_en)
myMatrix = lw_logtf(myMatrix) * gw_idf(myMatrix)
myLSAspace = createLSAspace(myMatrix, dims=dimcalc(method="share"))
showLSAspace(myLSAspace)

# clean up
unlink(td, recursive=TRUE)

}
\keyword{algebra}
\keyword{array}
