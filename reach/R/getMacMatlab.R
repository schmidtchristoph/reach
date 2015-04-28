#' Returns the name of the Matlab app of the latest version in the OSX Applications folder
#'
#' Utility function that returns the latest Matlab app (with the highest version number) in the OSX Applications folder.
#'
#' @return Latest Matlab application on Mac OSX
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 13.04.15

getMacMatlab <- function(){
   fil <- list.files("/Applications/")
   loc <- stringr::str_locate(fil, "MATLAB")
   ind <- which(!is.na(loc[,1]))

   matl <- fil[tail(ind,1)] # select Matlab corresponding to the last entry in 'ind' (should be highest Matlab version number)
   return(matl)
}
