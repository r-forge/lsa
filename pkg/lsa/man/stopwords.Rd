\name{stopwords}
\docType{data}
\alias{stopwords_de}
\alias{stopwords_en}
\alias{stopwords_nl}
\alias{stopwords_fr}
\alias{stopwords_pl}
\alias{stopwords_ar}
\title{Stopwordlists in German, English, Dutch, French, Polish, and Arab}
\description{
This data sets contain very common lists of words that want to be ignored when 
building up a document-term matrix. The stop word lists can be loaded by
calling \code{data(stopwords_en)}, \code{data(stopwords_de)}, 
\code{data(stopwords_nl)}, \code{data(stopwords_ar)}, etc. The objects \code{stopwords_de}, \code{stopwords_en}, \code{stopwords_nl}, \code{stopwords_ar}, etc. must already exist \emph{before} being handed over to \code{textmatrix()}.

The French stopword list has been combined by Haykel Demnati
by integrating the lists from rank.nl (www.rank.nl/stopwors/french.html), 
the one from the CLEF team at the University of Neuchatel 
(http://members.unine.ch/jacques.savoy/clef/frenchST.txt), 
and the one prepared by Jean Véronis
(http://sites.univ-provence.fr/veronis/data/antidico.txt).

The Polish stopword list has been contributed by Grazyna Paliwoda-Pekosz, Cracow University of Economics and is taken from the Polish Wikipedia.

The Arab stopword list has been contributed by Marwa Naili, Tunisia. The list is based on the stopword lists by Shereen Khoja and by Siham Boulaknadel.

}
\usage{
   data(stopwords_de)
   stopwords_de

   data(stopwords_en)
   stopwords_en

   data(stopwords_nl)
   stopwords_nl

   data(stopwords_fr)
   stopwords_fr

   data(stopwords_ar)
   stopwords_ar
}
\author{ Fridolin Wild \email{fridolin.wild@wu-wien.ac.at}, Marco Kalz \email{marco.kalz@ou.nl} (for Dutch), Haykel Demnati \email{Haykel.Demnati@isg.rnu.tn} (for French),
    Marwa Naili \email{naili.maroua@gmail.com} (for Arab) }
\format{A vector containing 424 English, 370 German, 260 Dutch, 890 French stop, or 434 Arab words (e.g. 'he', 'she', 'a').}
\keyword{datasets}
\keyword{array}
