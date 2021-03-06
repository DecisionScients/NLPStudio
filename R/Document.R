#' Document
#'
#' \code{Document} Entity class for text documents.
#'
#' Entity class for text documents with methods for adding text from character
#' vectors.
#'
#' @usage skiReport <- Document$new(name = "skiReport", purpose = 'Train')
#'
#' @section Core Methods:
#'  \itemize{
#'   \item{\code{new(name = NULL, purpose = NULL)}}{Initializes an object of the Document class.}
#'   \item{\code{text(x, note = NULL)}}{Method for obtaining/adding/updating text. If no
#'   parameters are presented, the current text is returned.  Otherwise, the text
#'   is updated with the texts of the character vector 'x'. Sentence, word, token, type,
#'   sentence and word length statistics are also computed and the metadata is updated
#'   accordingly.}
#'   \item{\code{overview()}}{Provides a subset of the metadata in a one-row data.frame format.
#'   This is used by the parent class's summary method.  }
#'  }
#' @param x Character vector of text.
#' @param name Character string containing the name for the Document object.
#' @param purpose Character string used to indicate how the document will be used, e.g. 'train', 'test'.
#' @param note Character string containing a comment associated with a call to the
#' text method. The texts of the note variable are written to the Documents
#' log. This is used to track changes to the text, perhaps made during preprocessing.
#' @template metadataParams
#'
#' @return Document object, containing the Document text, the metadata and
#' the methods to manage both.
#'
#'
#' @examples
#' report <- c("SAN FRANCISCO  — She was snowboarding with her boyfriend when ",
#'           "she heard someone scream 'Avalanche!'",
#'           "Then John, 39, saw 'a cloud of snow coming down.'")
#' avalanche <- Document$new(name = 'avalanche', purpose = 'raw')
#' avalance$content <- report
#' key <- c('genre', 'author', 'year')
#' value <- c('weather', 'chris jones', 2018)
#' avalanche$meta$setDescriptive(key = key value = value)
#'
#' @docType class
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Document Classes
#' @export
Document <- R6::R6Class(
  classname = "Document",
  lock_objects = FALSE,
  lock_class = FALSE,
  inherit = Primitive0,

  private = list(
    ..content = character(),

    compress = function(x) { memCompress(x, "g") },

    decompress = function(x) {
      strsplit(memDecompress(x, "g", asChar = TRUE), "\n")[[1]]
    },

    setQuant = function(x) {
      vectors <- length(x)
      sentences <- sum(tokenizers::count_sentences(x))
      gc()

      txt <- unlist(x)
      tokens <- unlist(tokenizers::tokenize_words(txt))
      words <- length(tokens)
      types <- length(unique(tokens))
      characters <- sum(tokenizers::count_characters(x))
      gc()

      k <- c("vectors", "sentences", "words", "types", "characters")
      v <- c(vectors, sentences, words, types, characters)
      private$meta$set(key = k, value = v, type = 'quant')
      return(TRUE)
    },

    processContent = function(x, note = NULL) {

      # Validate text
      if (!is.null(x)) {
        private$..params <- list()
        private$..params$classes$name <- list('x')
        private$..params$classes$objects <- list(x)
        private$..params$classes$valid <- list(c('character', 'list'))
        v <- private$validator$validate(self)
        if (v$code == FALSE) {
          private$logR$log(method = 'processContent',
                           event = v$msg, level = "Error")
          stop()
        }

        # Update text, compute statistics and update admin information
        private$..content <- private$compress(x)
        private$setQuant(x)
        private$meta$modified(event = note)
      }
      return(TRUE)
    }
  ),

  active = list(

    name = function(value) {
      if (missing(value)) {
        return(private$meta$get(key = 'name'))
      } else {

        # Validate class and length of value parameter.
        private$..params <- list()
        private$..params$classes$name <- list('value')
        private$..params$classes$objects <- list(value)
        private$..params$classes$valid <- list('character')
        v <- private$validator$validate(self)
        if (v$code == FALSE) {
          private$logR$log(method = 'name', event = v$msg, level = "Error")
          stop()
        }
        if (length(value) != 1) {
          event <- paste0("The value parameter for the 'name' method ",
                          "must be character a single string. See ?Document0 ",
                          "for further assistance.")
          private$logR$log(method = 'name', event = v$msg, level = "Error")
          stop()
        }
        private$meta$set(key = 'name', value = value, type = 'i')
        event <- paste0("Object name set to '", value, "' .")
        invisible(self)
      }
    },

    description = function(value) {
      if (missing(value)) {
        return(private$meta$get(key = 'description'))
      } else {

        # Validate class and length of value parameter.
        private$..params <- list()
        private$..params$classes$name <- list('value')
        private$..params$classes$objects <- list(value)
        private$..params$classes$valid <- list('character')
        v <- private$validator$validate(self)
        if (v$code == FALSE) {
          private$logR$log(method = 'description', event = v$msg, level = "Error")
          stop()
        }
        if (length(value) != 1) {
          event <- paste0("The value parameter for the 'description' method ",
                          "must be character a single string. See ?Document0 ",
                          "for further assistance.")
          private$logR$log(method = 'description', event = v$msg, level = "Error")
          stop()
        }
        private$meta$set(key = 'description', value = value, type = 'descriptive')
        event <- paste0("Object description set to '", value, "' .")
        invisible(self)
      }
    },

    content = function(value) {

      if (missing(value)) {
        if (length(private$..content) > 0) {
          if (is.raw(private$..content)) {
            return(private$decompress(private$..content))
          } else {
            return(private$..content)
          }
        } else {
          return(NULL)
        }
      } else {
        private$processContent(value)
      }
    }
  ),


  public = list(

    #-------------------------------------------------------------------------#
    #                           Core Methods                                  #
    #-------------------------------------------------------------------------#
    initialize = function(x = NULL, name = NULL) {

      private$loadServices(name)

      # Validate text
      if (!is.null(x)) {
        private$..params <- list()
        private$..params$classes$name <- list('x')
        private$..params$classes$objects <- list(x)
        private$..params$classes$valid <- list(c('character', 'list', 'File'))
        v <- private$validator$validate(self)
        if (v$code == FALSE) {
          private$logR$log(method = 'initialize',
                           event = v$msg, level = "Error")
          stop()
        }
        private$processContent(x)
      }

      private$logR$log(method = 'initialize',
                       event = "Initialization complete.")

      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                           Visitor Method                                #
    #-------------------------------------------------------------------------#
    accept = function(visitor)  {
      visitor$document(self)
    }
  )
)
