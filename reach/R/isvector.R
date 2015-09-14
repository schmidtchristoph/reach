#' Checks whether input variable is a vector
#'
#' An input is considered to be a vector if it has dimensions (n,1) or (1,n),
#' n>1. Returns TRUE if the input is a vector according to this definition.
#' Therefore, input that is a one-dimensional 'matrix' in R (is.matrix = TRUE
#' and is.vector = FALSE) would also be regarded as a vector.
#'
#' @param obj Data whose type is being tested to be a vector (n,1) or (1,n), n>1
#'
#' @return This function returns a boolean indicating whether input obj is a
#'   vector
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

# 14.09.15

# This function is merely a utility function and is part of the una package
# (utility functions for network analysis).
# It is distributed within reach for ease of use.

isvector <- function(obj){
   if(length(obj)<=1) { # scalar
      return(FALSE)
   }



   bool <- FALSE


   if(is.vector(obj)) {
      bool <- TRUE

   } else if(is.matrix(obj) & length(dim(obj))==2 & min(dim(obj))==1) {
      bool <- TRUE

   } else if(is.array(obj) & length(dim(obj))==1) {
      bool <- TRUE
   }

   return(bool)
}

