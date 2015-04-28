#' Checks whether input variable is a vector
#'
#' Returns TRUE if the input is either a vector in R (is.vector = TRUE) or the input
#' is a one-dimensional 'matrix' in R (is.matrix = TRUE).
#'
#' @param obj Data whose type is being tested to be a vector (n,1) or (1,n)
#'
#' @return This function returns a boolean indicating whether input obj is a vector
#'
#' @examples
#' v <- c(1, 2, 3)
#' reach:::isvector(v)
#'
#' reach:::isvector(t(v))
#'
#' m <- matrix(1:4, 2, 2)
#' reach:::isvector(m)
#'
#' v <- matrix(1:4, 4, 1)
#' reach:::isvector(v)
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 21.11.14

# This function is merely a utility function and is part of the una package
# (utility functions for network analysis).
# It is distributed within reach for ease of use.

isvector <- function(obj){
   if (is.vector(obj)) {
      return(TRUE)

   } else {
      if (is.matrix(obj) & length(dim(obj))==2 & min(dim(obj))==1) {
         return(TRUE)
      }


      if (is.array(obj) & length(dim(obj))==1) {
         return(TRUE)

      } else {
         return(FALSE)
      }
   }
}

