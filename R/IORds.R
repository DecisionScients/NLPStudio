#==============================================================================#
#                                 IORds                                        #
#==============================================================================#
#' IORds
#'
#'
#' \code{IORds} Class responsible for reading and writing Rds files.
#'
#' @usage IORds$new()$read(path)
#'
#' @template ioStrategyMethods
#'
#' @template ioStrategyParams
#'
#' @template ioStrategyReturn
#'
#' @docType class
#' @author John James, \email{jjames@@DataScienceSalon.org}
#' @family Input / Output Classes
#' @export
IORds <- R6::R6Class(
  classname = "IORds",
  lock_objects = TRUE,
  lock_class = FALSE,
  inherit = Super,

  public = list(

    #-------------------------------------------------------------------------#
    #                           Core Methods                                  #
    #-------------------------------------------------------------------------#
    initialize = function() {
      private$loadServices()
      invisible(self)
    },

    read = function(path, safe = FALSE) {

      fileName <- basename(path)

      if (file.exists(path)) {
        object <- readRDS(file = path)
        event <- paste0("Successfully read ", fileName, ".")
        private$logR$log( event = event)
      } else {
        event <- paste0('Unable to read ', fileName, '. ',
                                  'File does not exist.')
        private$logR$log(method = 'read', event = event, level = "Error")
        stop()
      }
      return(object)
    },

    write = function(path, content) {

      fileName <- basename(path)
      dirName <- dirname(path)

      # Create directory if necessary
      dir.create(dirName, showWarnings = FALSE, recursive = TRUE)

      saveRDS(object = content, file = path)

      event <- paste0("Successfully wrote ", fileName, ".")
      private$logR$log(method = 'write', event = event)

      invisible(self)
    }
  )
)
