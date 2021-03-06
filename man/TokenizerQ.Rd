% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/TokenizerQ.R
\docType{class}
\name{TokenizerQ}
\alias{TokenizerQ}
\title{TokenizerQ}
\format{An object of class \code{R6ClassGenerator} of length 24.}
\usage{
TokenizerQ
}
\arguments{
\item{x}{Corpus object}

\item{n}{Numeric for the nGram method. Indicates the nGram size.}
}
\value{
TokenizerQ object
}
\description{
\code{TokenizerQ} Wrapper class for the token functionality in the Quanteda package.
}
\details{
Creates character, word, sentence and paragraph tokens and nGrams using the
tokenizer package.
}
\section{Methods}{

 \itemize{
  \item{\code{new()}{Initializes an object of the TokenizerQ class.}}
  \item{\code{character(x)}}
  \item{\code{word(x)}}
  \item{\code{sentence(x)}}
  \item{\code{paragraph(x)}}
  \item{\code{nGrams(x, n)}}
 }
}

\seealso{
Other CorpusStudio Family of Classes: \code{\link{CorpusStudio}},
  \code{\link{KFold}}, \code{\link{Sample0}},
  \code{\link{Sample}}, \code{\link{Segment}},
  \code{\link{Split}}, \code{\link{TokenizerNLP}},
  \code{\link{Tokenizer}}, \code{\link{Token}}
}
\author{
John James, \email{jjames@datasciencesalon.org}
}
\concept{Corpus TokenizerQ Family of Classes}
\concept{CorpusStudio Family of Classes}
\keyword{datasets}
