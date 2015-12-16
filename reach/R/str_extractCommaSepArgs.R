#' Extract arguments given in a string, separated by commas
#'
#' Parses an input string and returns the comma separated arguments.
#'
#' @param args_str character vector containing (variable) names separated by
#'   commas
#'
#' @return Returns a list containing the (variable) names (characters) stored in
#'   \code{args_str}.
#'
#' @examples
#' vars    <- "A, B, myChar, level, k,  test, te_st  , newval"
#' reach:::str_extractCommaSepArgs(vars)
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 11.12.15

str_extractCommaSepArgs <- function(args_str){
   inp       <- list()
   ind_start <- 1
   k         <- 1
   bool      <- TRUE


   while(bool){
      args_str     <- stringr::str_sub( args_str, ind_start )
      ind_end    <- stringr::str_locate( args_str, "," )[1,1]

      if(is.na(ind_end)){
         bool    <- FALSE
         ind_end <- stringr::str_length(args_str) + 1
      }

      this_arg   <- stringr::str_sub( args_str, 1, ind_end-1 )
      inp[[k]]   <- stringr::str_trim(this_arg)
      ind_start  <- ind_end + 1
      k          <- k + 1
   }

   return(inp)
}
