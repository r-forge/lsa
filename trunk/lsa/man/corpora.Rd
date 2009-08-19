\name{corpora}
\docType{data}
\alias{corpus_training}
\alias{corpus_essays}
\alias{corpus_scores}
\title{Corpora (Essay Scoring)}
\description{
This data sets contain example corpora for essay scoring.
A training textmatrix contains files to construct a 
latent semantic space apt for grading student essays
provided in the essay textmatrix. In a separate data
set, the original human scores are noted down with
which the student essays were graded by a human
assessor. The corpora (and human scores) can be loaded by
calling \code{data(corpus_training)}, \code{data(corpus_essays)}, or
\code{data(corpus_scores)}. The objects must already 
exist \emph{before} being handed over to e.g. \code{lsa()}.
}
\usage{
   data(corpus_training)
   data(corpus_essays)
   data(corpus_scores)
}
\author{ Fridolin Wild \email{f.wild@open.ac.uk} }
\format{ Corpora: textmatrix; Scores: table.}
\keyword{datasets}
\keyword{array}
