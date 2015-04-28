#' Reformats an R list to be exported to Matlab as cell-array
#'
#' Exporting a R list with unnamed entries to Matlab using the
#' R.matlab::writeMat function yields a Matlab struct with no fields (an empty
#' struct). With the help of the matlabExportList function such a R list is
#' reformated so that the export results in a struct with fields (1,2,...),
#' accessible with the Matlab getfield() function. In Matlab, the loaded struct
#' can then be further processed with the Matlab function 'rList2Cell()', which
#' is distributed with this package, to yield a Matlab cell-array. For export,
#' the package 'R.matlab' has to be used. Note that in particular for storing a
#' multidimensional matrix one can also use R arrays instead of lists
#' (a<-array(dim=c(3,3,2); a[,,1]<-matrix(99,3,3); ...) which will be exported
#' just fine to Matlab and don't need any further processing.
#'
#' @param rlist List that is exported to Matlab as cell-array
#'
#' @details A list containing lists is not supported by the writeMat() function and provokes an error.
#' Consequently, this is checked for in matlabExportList and triggers an error.
#'
#' @return This function returns a reformated list that can be exported to Matlab with writeMat().
#' In Matlab it should be transformed to a cell-array using the Matlab function 'rList2Cell()', which is
#' distributed with this package.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' rlist <- list(matrix(99,4,4), c(1,2,3,4), "somestring")
#' print(rlist)
#' matlablist <- matlabExportList(rlist)
#' print(matlablist)
#' R.matlab::writeMat("test.mat", myexportdata=matlablist)
#' # in Matlab:
#' runMatlabCommand("'load test.mat; myexportdata,
#'       rcell=rList2Cell(myexportdata); celldisp(rcell); quit'")
#' system("rm test.mat")
#' }
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 21.11.14

matlabExportList <- function(rlist){
   # CHECKING IF RLIST IS A LIST OF LISTS
   for (k in 1:length(rlist)) {
      if (is.list(rlist[[k]])) {
         stop('Input rlist is a list containing sub-lists. Cannot be exported with writeMat(). You should use separate lists.')
      }
   }



   # DETERMINING IF RLIST CONTAINS ANY MULTI-ARRAYS AND TRANSPOSING VECTOR FOR CORRECT MATLAB EXPORT
   ismarray <- FALSE

   for (k in 1:length(rlist)){
      entry <- rlist[[k]]

      if (isvector(entry) & !is.character(entry)) {
         rlist[[k]] <- t(entry) # vectors are for some reason transposed upon Matlab import, so with t() here, they appear in Matlab as in rlist
      }


      if (length(dim(entry))>2 && class(entry[,,1])=='matrix') {
         ismarray <- TRUE
      }
   }



   tmp <- list()


   if (ismarray) { # rlist contained a multi-array
      tmp2  <- list()

      for (k in 1:length(rlist)){
         if (length(dim(rlist[[k]]))>2 && class(rlist[[k]][,,1])=='matrix') {
            tmp[[paste(1,k,sep='')]] <- dim(rlist[[k]]) # storing dimension information for reshape

         } else {
            tmp [[paste(1,k,sep='')]] <- 'NO_MULTI'
         }

         tmp2[[paste(2,k,sep='')]] <- rlist[[k]] # the actual data
      }

      matlablist <- c('0'='FORMATLAB', tmp, tmp2)



   } else {
      for (k in 1:length(rlist)){
         tmp[[as.character(k)]] <- rlist[[k]]
      }

      matlablist <- tmp
   }



   return(matlablist)
}

