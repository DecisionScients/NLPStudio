#' CSource0
#'
#' \code{CSource0} Abstract class that defines the interface for the concrete CSource classes
#'
#' @section Methods:
#'  \itemize{
#'   \item{\code{new()}}{Initializes an object of the CSource0 class.}
#'   \item{\code{source(x, name = NULL)}}{Executes the process of sourcing the Corpus object.}
#'  }
#'
#' @param name Optional character vector indicating name for Corpus object.
#' @param x Character vector containing text, the name of a file, or directory
#' or a corpus object from a supported package.
#'
#'
#' @docType class
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Corpus Source Classes
#' @export
CSource0 <- R6::R6Class(
  classname = "CSource0",
  lock_objects = FALSE,
  lock_class = FALSE,
  inherit = Super,

  private = list(
    ..corpus = character()
  ),

  public = list(

    initialize = function() { stop("This method is not implemented for this abstract class") },
    source = function() { stop("This method is not implemented for this abstract class") }
  )
)
