#' Converts an eligible Matlab .mat file to an .RData file
#'
#' Converts an eligible Matlab .mat file to an .RData file. Keeps the .mat file unchanged.
#' The Matlab file must have been saved with the -v7 option flag.
#'
#' @param matfile A string denoting the matfile, e.g. "mymatlabdata" or "mymatlabdata.mat"
#'
#' @seealso \code{\link{runMatlabScript}}, \code{\link{runMatlabCommand}}
#'
#' @export
#'
#' @examples
#' v <- sample(1:10,4)
#' m <- matrix(runif(9),3,3)
#' print(v)
#' print(m)
#' R.matlab::writeMat("test_convert2RData.mat", v=v, m=m)
#' rm(m,v)
#' convert2RData("test_convert2RData.mat")
#' load("test_convert2RData.RData")
#' print(v)
#' print(m)
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 27.02.15


convert2RData <- function(matfile){
   ind <- stringr::str_locate(matfile,".mat")
   if(!is.na(ind[1])) matfile <- stringr::str_sub(matfile, 1, ind[1]-1) # file type specifier was provided


   writeLines(paste("Loading", matfile))
   inp <- R.matlab::readMat(paste(matfile, ".mat", sep=""))


   for(k in 1:length(inp)) assign(names(inp)[k], inp[[names(inp)[k]]])


   save(list=names(inp), file = paste(matfile, ".RData", sep=""))
   writeLines("Finished saving corresponding .RData file.")
}

