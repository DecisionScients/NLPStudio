#------------------------------------------------------------------------------#
#                            ConverterQ                                 #
#------------------------------------------------------------------------------#
#' ConverterQ
#'
#' \code{ConverterQ} Converts NLPStudio Corpus objects to and from Quanteda corpus objects.
#'
#' @usage ConverterQ$new()$convert(x)
#'
#' @param x Object to be converted
#'
#' @docType class
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Converter Classes
#' @export
ConverterQ <- R6::R6Class(
  classname = "ConverterQ",
  lock_objects = FALSE,
  lock_class = FALSE,
  inherit = Converter0,

  private = list(

    to = function(x) {

      # Obtain corpus and document metadata
      corpusMeta <- x$getMeta()
      docMeta <- x$getDocMeta(classname = 'Document')

      # Obtain documents
      docs <- x$getDocuments()

      # Convert list of text to character vectors
      text = character()
      for (i in 1:length(docs)) {
        text[i] <- paste(docs[[i]]$content, collapse = '')
      }

      #..and obtain text names
      docNames <- unlist(lapply(docs, function(d) { d$getName() }))

      # Create quanteda corpus object
      qCorpus <- quanteda::corpus(text, docnames = docNames)

      # Assign corpus level metadata from descriptive metadata
      corpusMeta <- corpusMeta$descriptive
      if (length(corpusMeta) > 0 ) {
        vars <- names(corpusMeta)
        for (i in 1:length(vars)) {
            quanteda::metacorpus(qCorpus, vars[i]) <- corpusMeta[[i]]
        }
      }

      # Assign docvars
      docVars <- as.data.frame(docMeta$Document$descriptive)
      if (nrow(docVars) > 0) {
        vars <- names(docVars)
        for (i in 1:length(vars)) {
          quanteda::docvars(x = qCorpus, field = vars[i]) <- docVars[,i]
        }
      }

      # Assign metadoc variables
      metaDoc <- as.data.frame(docMeta$Document$functional)
      if (nrow(metaDoc) > 0) {
        vars <- names(metaDoc)
        for (i in 1:length(vars)) {
          metadoc(x = qCorpus, field = vars[i]) <- metaDoc[,i]
        }
      }

      return(qCorpus)

    },

    from = function(x) {

      # Create NLPStudio Corpus
      corpus <- Corpus$new()

      # Obtain and transfer corpus metadata
      descriptive <- quanteda::metacorpus(x)[!names(quanteda::metacorpus(x)) %in% c('source', 'created')]
      vars <- names(descriptive)
      if (length(descriptive) > 0)  corpus$setMeta(key = vars, value = descriptive, type = 'd')
      corpus$setMeta(key = 'source', value = quanteda::metacorpus(x)['source'][1], type = 'f')

      # Create Document Objects from quanteda corpus text and add to corpus
      docNames <- quanteda::docnames(x)
      for (i in 1:length(x$documents$texts)) {
        doc <- Document$new(x = x$documents$texts[i], name = docNames[i])
        doc$setMeta(key = 'source',
                    value = paste0('Quanteda Corpus, ', docNames[i]),
                    type = 'f')
        corpus$addDocument(doc)
      }

      # Add document descriptive metadata
      if (ncol(quanteda::docvars(x)) > 0) {
        corpus$setDocMeta(docMeta = quanteda::docvars(x), classname = 'Document',
                          type = 'd')
      }

      # Add document functional metadata
      if (ncol(quanteda::metadoc(x)) > 0) {
        corpus$setDocMeta(docMeta = quanteda::metadoc(x), classname = 'Document',
                          type = 'f')
      }

      return(corpus)
    }
  ),

  public = list(

    #-------------------------------------------------------------------------#
    #                       Initialization Method                             #
    #-------------------------------------------------------------------------#
    initialize = function() {

      private$loadServices()

      event <- paste0("Initiated ", private$..classname)
      private$logR$log(method = 'initialize', event = event)

      invisible(self)


    },
    #-------------------------------------------------------------------------#
    #                           Conversion Methods                            #
    #-------------------------------------------------------------------------#
    convert = function(x) {

      private$..methodName <- 'convert'

      if (class(x)[1] == "Corpus") {
        return(private$to(x))
      } else if (class(x)[1] == "corpus") {
        return(private$from(x))
      } else {
        event <- paste0("This class operates on Corpus and quanteda ",
                                  "corpus objects only.")
        private$logR$log(method = 'convert', event = event, level = "Error")
        stop()
      }
    },

    #-------------------------------------------------------------------------#
    #                              Visitor Method                             #
    #-------------------------------------------------------------------------#
    accept = function(visitor)  {
      visitor$converterQuanteda(self)
    }
  )
)
