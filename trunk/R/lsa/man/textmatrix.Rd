\name{textmatrix}
\alias{textmatrix}
\alias{textvector}
\title{Textmatrix (Matrices)}
\description{
  Creates a document-term matrix from all textfiles in a given directory.
}
\usage{
textmatrix ( mydir, stemming=FALSE, language="german", 
   minWordLength=2, minDocFreq=1, stopwords=NULL, vocabulary=NULL )
textvector ( file, stemming=FALSE, language="german", 
   minWordLength=2, minDocFreq=1, stopwords=NULL, vocabulary=NULL )
}
\arguments{
   \item{file}{filename (may include path).}
   \item{mydir}{the directory path (e.g. 'corpus/texts/').}
   \item{stemming}{boolean indicating whether to reduce all terms to their wordstem.}
   \item{language}{specifies language for the stemming / stop-word-removal.}
   \item{minWordLength}{words with less than minWordLength characters will be ignored.}
   \item{minDocFreq}{words of a document appearing less than minDocFreq within that document will be ignored.}
   \item{stopwords}{a stopword list that contains terms the will be ignored.}
   \item{vocabulary}{if specified, only words in this term list will be used for building the matrix ('controlled vocabulary').}
}
\details{
  All documents in the specified directory are read and a matrix is composed.
  The matrix contains in every cell the exact number of appearances (=the term frequency) 
  of every word for all documents. If specified, simple text preprocessing mechanisms
  are applied (stemming, stopword filtering, wordlength cutoffs).
  
  Stemming thereby uses porter's snowball stemmer (from package \code{Rstem}).
  
  There are two stopword lists included (for english and for german), which
  are loaded on demand into the variables \code{stopwords_de} and 
  \code{stopwords_en}. They can be activated by calling \code{data(stopwords_de)}
  or \code{data(stopwords_en)}. Attention: the stopword lists have
  to be already loaded when \code{textmatrix()} is called.
  
  \code{textvector()} is a support function that creates a list of
  term-in-document occurrences.
  
  For every generated matrix, an own environment is created which
  holds the triples that are stored by \code{setTriple()} and can be
  retrieved with \code{getTriple()}.
  
}
\value{
  \item{textmatrix}{the document-term matrix (incl. row and column names).}
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\seealso{ \code{\link[Rstem]{wordStem}}, \code{\link{stopwords_de}}, \code{\link{stopwords_en}}, \code{\link{setTriple}}, \code{\link{getTriple}}}
\examples{

# create some files
td = paste(tempdir(), "lsatest", sep="/")
dir.create(td)
write( c("dog", "cat", "mouse"), file=paste(td, "D1", sep="/") )
write( c("hamster", "mouse", "sushi"), file=paste(td, "D2", sep="/") )
write( c("dog", "monster", "monster"), file=paste(td, "D3", sep="/") )

# read them, create a document-term matrix
textmatrix(td)

# read them, drop german stopwords
data(stopwords_de)
textmatrix(td, stopwords=stopwords_de)

# read them based on a controlled vocabulary
voc = c("dog", "mouse")
textmatrix(td, vocabulary=voc, minWordLength=1)

# clean up
unlink(td, recursive=TRUE)

}
\keyword{textmatrix}
