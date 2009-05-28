\name{stopwords}
\docType{data}
\alias{stopwords_de}
\alias{stopwords_en}
\alias{stopwords_nl}
\alias{stopwords_german}
\alias{stopwords_english}
\alias{stopwords_dutch}
\title{Stopwordlists in German, English, Dutch, and French}
\description{
This data sets contain very common lists of words that want to be ignored when 
building up a document-term matrix. The stop word lists can be loaded by
calling \code{data(stopwords_en)}, \code{data(stopwords_de)}, or
\code{data(stopwords_nl)}. The objects \code{stopwords_de}, \code{stopwords_en}, 
and \code{data(stopwords_nl)} must already exist \emph{before}
being handed over to \code{textmatrix()}.

The French stopword list has been combined by Haykel Demnati
by integrating the lists from rank.nl (www.rank.nl/stopwors/french.html), 
the one from the CLEF team at the University of Neuchatel 
(http://members.unine.ch/jacques.savoy/clef/frenchST.txt), 
and the one prepared by Jean Véronis
(http://sites.univ-provence.fr/veronis/data/antidico.txt).

}
\usage{
   data(stopwords_de)
   data(stopwords_en)
   data(stopwords_nl)
   data(stopwords_fr)
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at}, Marco Kalz \email{marco.kalz@ou.nl} (for Dutch), Haykel Demnati \email{Haykel.Demnati@isg.rnu.tn} (for french) }
\format{A vector containing 424 English, 370 German, 260 Dutch, or 890 French stop words (e.g. 'he', 'she', 'a').}
\keyword{datasets}
\keyword{array}
