#==============================================================================#
#                                   IOFactory                                  #
#==============================================================================#
#' IOFactory
#'
#' \code{IOFactory} Factory class that creates the appropriate IO class.
#'
#' Class creates IO objects based upon the file type
#'
#' @section IOFactory methods:
#' \describe{
#'  \item{\code{new()}}{Instantiates the factory.}
#'  \item{\code{getFilesStrategy(fileName)}}{Instantiates and returns the appropriate File Strategy object.}
#' }
#'
#' @param path Character string containing the path for file
#'
#' @return Concrete IO strategy.
#'
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @docType class
#' @family IO Classes
#' @export
IOFactory <- R6::R6Class(
  "IOFactory",
  lock_class = FALSE,
  lock_objects = FALSE,
  inherit = Super,

  private = list(
    ..path = character()
  ),

  public = list(

    #-------------------------------------------------------------------------#
    #                      Object Creation and Read                           #
    #-------------------------------------------------------------------------#
    initialize = function() {
      private$loadServices()
      invisible(self)
    },

    strategy = function(path) {

      type <- tolower(tools::file_ext(path))
      supportedTypes <- c('txt', 'csv', 'rdata', 'rds')

      if (!(type %in% supportedTypes)) {
        event <- paste0("File type, ", type, ", is not currently supported. ",
                       "Supported file types include ", supportedTypes, ".",
                       "See ", class(self)[1], " for further assistance.")
        private$logR$log(method = 'strategy', event = event, level = "Error")
        stop()
      }

      io <- switch(type,
                   txt = IOText$new(),
                   csv = IOCSV$new(),
                   rdata = IORdata$new(),
                   rds = IORds$new())

      return(io)
    },

    #-------------------------------------------------------------------------#
    #                           Visitor Method                                #
    #-------------------------------------------------------------------------#
    accept = function(visitor)  {
      visitor$IOFactory(self)
    }
  )
)
