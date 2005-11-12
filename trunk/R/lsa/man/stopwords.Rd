\name{stopwords}
\docType{data}
\alias{stopwords_de}
\alias{stopwords_en}
\alias{stopwords_german}
\alias{stopwords_english}
\title{Stopwordlists in German and English}
\description{
This data sets contain very common lists of words that want to be ignored when 
building up a document-term matrix. The stop word lists can be loaded by
calling \code{data(stopwords_en)} and \code{data(stopwords_de)}. The objects
\code{stopwords_de} and \code{stopwords_en} must already exist \emph{before}
being handed over to \code{textmatrix()}.
}
\usage{
   data(stopwords_de)
   data(stopwords_en)
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at} }
\format{A vector containing 424 (English) resp. 370 (German) stop words (e.g. 'he', 'she', 'a').}
\keyword{datasets}
