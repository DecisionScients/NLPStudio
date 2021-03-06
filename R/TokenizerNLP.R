#' TokenizerNLP
#'
#' \code{TokenizerNLP} Wrapper class for the OpenNLP package tokens functions
#'
#' Creates character, word, sentence and paragraph tokens and nGrams using the
#' OpenNLP package.
#'
#' @section Methods:
#'  \itemize{
#'   \item{\code{new()}{Initializes an object of the TokenizerNLP class.}}
#'   \item{\code{character(x)}}
#'   \item{\code{word(x)}}
#'   \item{\code{sentence(x)}}
#'   \item{\code{paragraph(x)}}
#'   \item{\code{nGrams(x, n)}}
#'  }
#'
#' @param x Corpus object
#' @param n Numeric for the nGram method. Indicates the nGram size.
#' @return TokenizerNLP object
#'
#' @docType class
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Corpus TokenizerNLP Family of Classes
#' @family CorpusStudio Family of Classes
#' @export
TokenizerNLP <- R6::R6Class(
  classname = "TokenizerNLP",
  lock_objects = FALSE,
  lock_class = FALSE,
  inherit = Super,

  private = list(
    ..x = character(),
    ..tokenizedCorpus = character(),
    ..nGrams = character(),

    #-------------------------------------------------------------------------#
    #                           Validation Method                             #
    #-------------------------------------------------------------------------#
    validate = function(x) {
      private$..params <- list()
      private$..params$classes$name <- list('x')
      private$..params$classes$objects <- list(x)
      private$..params$classes$valid <- list(c('Corpus'))
      v <- private$validator$validate(self)
      if (v$code == FALSE) {
        private$logR$log(method = 'execute', event = v$msg, level = "Error")
        stop()
      }

      return(TRUE)
    },

    #-------------------------------------------------------------------------#
    #                           Tokenize Methods                              #
    #-------------------------------------------------------------------------#
    tokenizeSentences = function(x) {
      s <- paste(x, collapse = "")
      s <- NLP::as.String(s)

      ## Need sentence token annotations.
      sent_token_annotator <- openNLP::Maxent_Sent_Token_Annotator()
      a1 <- NLP::annotate(s, sent_token_annotator)
      return(as.character(s[a1]))
    },

    tokenizeWords = function(x) {

      s <- paste(x, collapse = "")
      s <- NLP::as.String(s)

      ## Need sentence token annotations.
      sent_token_annotator <- openNLP::Maxent_Sent_Token_Annotator()
      a1 <- NLP::annotate(s, sent_token_annotator)
      ## Need word token annotations.
      word_token_annotator <- openNLP::Maxent_Word_Token_Annotator()
      a2 <- NLP::annotate(s, word_token_annotator, a1)
      # Extract words
      a2w <- subset(a2, type == 'word')
      return(as.character(s[a2w]))
    },

    tokenize = function(x, tokenUnit) {


      if (grepl("^w", tokenUnit, ignore.case = TRUE)) {
        return(private$tokenizeWords(x = x))

      } else if (grepl("^s", tokenUnit, ignore.case = TRUE)) {
        return(private$tokenizeSentences(x = x))

      } else {
        event <- paste0("Invalid token unit. Must be c('word',",
                        " 'sentence'). See ?", class(self)[1],
                        " for further assistance.")
        private$logR$log(method = 'tokenize', event = event, level = "Error")
        stop()
      }
    },

    #-------------------------------------------------------------------------#
    #                           Execute Method                                #
    #-------------------------------------------------------------------------#
    execute = function(tokenUnit) {

      # Create tokens object
      private$..tokenizedCorpus <- Clone$new()$this(private$..x, reference = FALSE,
                                           content = FALSE)

      # Initialize counts
      totalCounts <- 0

      documents <- private$..x$getDocuments()

      for (i in 1:length(documents)) {

        # Clone document
        document <- Clone$new()$this(documents[[i]],  content = TRUE)

        # Tokenize
        document$content <- private$tokenize(paste(document$content,
                                                   collapse = " "),
                                             tokenUnit)

        # Get Counts
        counts <- length(document$content)
        totalCounts <- totalCounts + counts

        # Update documents metadata
        name <- document$getName()
        name <- paste0(name, " (", tokenUnit, " Tokens)")
        document$setName(name)
        document$setMeta(key = 'tokenizer', value = 'openNLP Package', type = 'f')
        document$setMeta(key = 'tokenUnit', value = tokenUnit, type = 'f')
        document$setMeta(key = paste(tokenUnit, "Tokens"), value = counts, type = 'q')

        private$..tokenizedCorpus$addDocument(document)

      }

      # Update corpus metadata
      name <- private$..tokenizedCorpus$getName()
      name <- paste0(name, " (", tokenUnit," Tokens)")
      private$..tokenizedCorpus$setName(name)
      private$..tokenizedCorpus$setMeta(key = 'tokenizer', value = 'openNLP Package', type = 'f')
      private$..tokenizedCorpus$setMeta(key = 'tokenUnit', value = tokenUnit, type = 'f')
      private$..tokenizedCorpus$setMeta(key = paste(tokenUnit, "Tokens"), value = totalCounts, type = 'q')
      return(TRUE)
    }
  ),

  public = list(

    #-------------------------------------------------------------------------#
    #                             Constructor                                 #
    #-------------------------------------------------------------------------#
    initialize = function() {
      private$loadServices("TokenizerNLP")
      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                        Character Tokens Method                          #
    #-------------------------------------------------------------------------#
    chars = function(x) {

      stop("This method is not implemented for this class.")

      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                           Word Tokens Method                            #
    #-------------------------------------------------------------------------#
    words = function(x) {

      private$validate(x)
      private$..x <- x
      private$execute(tokenUnit = 'Word')

      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                       Sentence Tokens Method                            #
    #-------------------------------------------------------------------------#
    sentences = function(x) {

      private$validate(x)
      private$..x <- x
      private$execute(tokenUnit = 'Sentence')

      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                       Paragraph Tokens Method                           #
    #-------------------------------------------------------------------------#
    paragraphs = function(x) {

      stop("This method is not implemented for this class.")

      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                            NGrams Method                                #
    #-------------------------------------------------------------------------#
    nGrams = function(x) {

      stop("This method is not implemented for this class.")

      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                               Get Methods                               #
    #-------------------------------------------------------------------------#
    getCorpus = function() private$..tokenizedCorpus,
    getTokens = function() {
      documents <- private$..tokenizedCorpus$getDocuments()
      tokenGrams <- unlist(lapply(documents, function(d) {d$content}))
      return(tokenGrams)
    },

    #-------------------------------------------------------------------------#
    #                           Visitor Method                                #
    #-------------------------------------------------------------------------#
    accept = function(visitor)  {
      visitor$tokenizerNLP(self)
    }
  )
)
