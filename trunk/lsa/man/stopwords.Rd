\name{stopwords}
\docType{data}
\alias{stopwords_de}
\alias{stopwords_en}
\alias{stopwords_nl}
\alias{stopwords_german}
\alias{stopwords_english}
\alias{stopwords_dutch}
\title{Stopwordlists in German, English, and Dutch}
\description{
This data sets contain very common lists of words that want to be ignored when 
building up a document-term matrix. The stop word lists can be loaded by
calling \code{data(stopwords_en)}, \code{data(stopwords_de)}, or
\code{data(stopwords_nl)}. The objects \code{stopwords_de}, \code{stopwords_en}, 
and \code{data(stopwords_nl)} must already exist \emph{before}
being handed over to \code{textmatrix()}.
}
\usage{
   data(stopwords_de)
   data(stopwords_en)
   data(stopwords_nl)
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at}, Marco Kalz \email{marco.kalz@ou.nl} (for Dutch) }
\format{A vector containing 424 (370) English (German) stop words (e.g. 'he', 'she', 'a').}
\keyword{datasets}
\keyword{array}
