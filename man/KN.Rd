% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/KN.R
\docType{class}
\name{KN}
\alias{KN}
\title{Kneser Ney}
\format{An object of class \code{R6ClassGenerator} of length 24.}
\usage{
KN
}
\arguments{
\item{x}{a CVSet containing training and test Corpus objects}

\item{train}{Train Corpus object. Ignored if x is a CVSet, required otherwise.}

\item{test}{Test Corpus object. Ignored if x is a CVSet, required otherwise.}

\item{modelSize}{Numeric between 1, for unigram to 5 for quintgram.}

\item{openVocabulary}{Logical. If TRUE, preprocessing will replace all words
in the test corpus that are not in the training corpus with the pseudo-word
UNK. If FALSE, all words in test corpus are assumed to be in the training
corpus. The default is TRUE.}
}
\description{
\code{KN} Kneser-Ney Statistical Learning Model
}
\details{
Encapsulates a Statistical Language Model implementing the Kneser-Ney
smoothing algorithm.
}
\seealso{
Other Statistical Language Model Classes: \code{\link{Katz}},
  \code{\link{MKN}}, \code{\link{SLM0}}
}
\author{
John James, \email{jjames@dataScienceSalon.org}
}
\concept{Statistical Language Model Classes}
\keyword{datasets}
