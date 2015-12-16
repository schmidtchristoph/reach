#' Writes .mat files for exporting data to be used with Matlab
#'
#' Writes .mat files to store R session data using the R.matlab package and
#' takes care that logicals and atomic vectors are saved properly: currently,
#' R.matlab does not write logicals and atomic vectors (not 1D arrays/ matrices)
#' in a way that they can be opened properly in Matlab (logicals will not be
#' stored and atomic vectors will be transposed in the Matlab session - but they
#' appear untransposed when read back from the .mat file into R using
#' R.matlab::readMat()). This function is a convenient wrapper for
#' R.matlab::writeMat() that stores logicals as 0 / 1 and that transposes atomic
#' vectors when saving the matfile.
#'
#' @param fn file name, a character string
#'
#' @param vars character vector containing a comma separated listing of
#'   variables to be saved in the matfile. The variables have to exist in the
#'   environment where the function was called from.
#'
#' @export
#'
#' @examples
#' A       <- matrix(c(2,3,4,2, 1,1,2,6, 8,3,9,7), 3, 4, byrow = TRUE)
#' b       <- c(3, 5, 1, 9, 18, 2) # atomic vector 1x6
#' cc      <- array(b, c(1, length(b))) # array vector 1x6
#' dd      <- t(cc) # array vector 6x1
#' myChar  <- c("from", "R", "to", "Matlab")
#' bool    <- TRUE # logical
#' k       <- FALSE
#' l       <- FALSE
#' fn      <- "mytestmat"
#' vars    <- "A, b, cc, dd, myChar, bool, k, l"
#' matWrite(fn, vars)
#' unlink(paste(fn, ".mat", sep = ""))
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 17.12.15

matWrite <- function(fn, vars){
   if(!stringr::str_detect(fn, "^.*\\.mat$")){
      fn <- paste(fn, ".mat", sep = "")
   }




   varsList <- str_extractCommaSepArgs(vars)
   saveVars <- ""

   # strange iterator name to circumvent manipulating a global variable that should
   # be saved to .mat, e.g. k, i, ...
   for(kqzuacrlk in 1:length(varsList)){
      tmpStr  <- varsList[[kqzuacrlk]]
      tmpStr_ <- paste(tmpStr, '_', sep = "") # for storing local copy of global variable from parent frame

      if( !exists(tmpStr, envir = parent.frame()) ){
         stop(paste("Input variable name: '", tmpStr,
                    "'\ndoes not correspond to a variable stored in the parent frame.", sep = ""))
      }


      tmpVal  <- get(tmpStr, envir = parent.frame())


      # is.vector(list) = TRUE, is.vector(logical) = TRUE, is.vector(array) = FALSE, is.list(vector) = FALSE
      # does not transpose one-dimensional matrices / arrays (they don't need to be transformed)
      if(is.vector(tmpVal) && !is.list(tmpVal) && !is.logical(tmpVal)){
         assign(tmpStr_, t(tmpVal)) # create new local variable containing the transpose of the corresponding parent.frame atomic vector
      }
      else if(is.logical(tmpVal)){
         if(tmpVal){
            assign(tmpStr_, 1) # create new local variable containing the corresponding integer encoding of the corresponding parent.frame logical
         }
         else {
            assign(tmpStr_, 0)
         }
      }
      else {
         assign(tmpStr_, tmpVal)
      }


      saveVars <- paste(saveVars, tmpStr, " = ", tmpStr_, ",", sep = "")
   }


   saveVars <- stringr::str_sub(saveVars, end = -2L) # deleting last comma



   ### saving .mat file ---
   f <- paste("R.matlab::writeMat('", fn, "', ", saveVars, ")", sep = "")
   eval(parse(text=f))
}
