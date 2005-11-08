\name{pseudodtm}
\alias{pseudo_docs}
\alias{query}
\alias{pseudo_svd}
\title{Pseudo Document Term Matrix (Matrices)}
\description{
  Fold-in a pseudo document or a query into an existing latent-semantic space. 
}
\usage{
pseudo_docs ( docdir, termlist, stemming=FALSE, 
              language="german" )
query ( qtext, termlist, stemming=FALSE, language="german" )
pseudo_svd ( docvecs, tk, sk )
}
\arguments{
   \item{docdir}{the directory path to the documents (e.g. "corpus/texts/").}
   \item{termlist}{the termlist of the background latent-semantic space.}
   \item{language}{specifies language for the stemming / stop-word-removal.}
   \item{stemming}{boolean, specifies whether all terms will be reduced to their wordstems.}
   \item{qtext}{the query string, words are separated by blanks ' '.}
   \item{docvecs}{the document-term-vectors that shall be converted to document-term-vectors in the reduced (=latent-semantic) space.}
   \item{tk}{the left-sided matrix of the SVD (the 'terms' matrix) of the background corpus.}
   \item{sk}{the descending sequence of singular values, as produced by the SVD of the background corpus.}
}
\details{
  Create pseudo documents, queries and a pseudo SVD for files from a given directory.
}
\value{
  \item{pseudo_docs}{returns the document-term-matrix for the new files (based on the given vocabulary).}
  \item{query}{returns the query vector (based on the given vocabulary) as matrix.}
  \item{pseudo_svd}{returns the converted document-term-vectors as matrix.}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{
\code{\link[Rstem]{wordStem}}, for more information see \code{\link{dt_matrix}} 
}
\examples{

dir.create("tmp_dtm_test")
write( c("dog", "cat", "mouse"), file="tmp_dtm_test/data_doc1.dt")
write( c("hamster", "mouse", "sushi"), file="tmp_dtm_test/data_doc2.dt")
write( c("dog", "monster", "monster"), file="tmp_dtm_test/data_doc3.dt")

dir.create("tmp_dtm_test2")
write( c("dog", "monster", "cat"), file="tmp_dtm_test2/data_doc1.dt")
write( c("hamster", "dog", "sushi"), file="tmp_dtm_test2/data_doc2.dt")
write( c("dog", "monster", "dog"), file="tmp_dtm_test2/data_doc3.dt")

## demonstrate generation of a pseudo doc and a query

dtm = dt_matrix("tmp_dtm_test/")
query("dog", rownames(dtm))
pdocs = pseudo_docs("tmp_dtm_test2/", rownames(dtm))

## demonstrate fold-in of (raw) document vectors into 
## the latent-semantic space.

SVD = svd(dtm)
k = 2 # reduce to two dimensions
tk = SVD$u[,1:k]
sk = SVD$d[1:k]
pseudo_svd( pdocs, tk, sk)

unlink("tmp_dtm_test", TRUE)
unlink("tmp_dtm_test2", TRUE)

}
\keyword{algebra}
\keyword{array}
