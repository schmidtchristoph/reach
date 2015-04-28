#' Starts Matlab on the R console and executes the input script
#'
#' Starts Matlab on the R console, executes the input script and quits Matlab.
#' Discerns the Mac and Linux Matlab command.
#'
#' @param scriptName String denoting the .m script (with or without the file extension)
#'
#' @details As R and Matlab cannot directly exchange data natively, no value will be returned directly.
#' Instead, let Matlab save the results of its computations and load these into R for further processing.
#' See also the following system call example:
#' system('/Applications/MATLAB_R2013a.app/bin/matlab -nosplash -nodesktop -r "S_test; quit;"')
#' An error in the Matlab script prevents Matlab from quitting in the R console and might
#' require an re-start of the R session. So check the script in Matlab before executing it within R.
#'
#' @seealso \code{\link{convert2RData}}, \code{\link{runMatlabCommand}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' scriptName <- "myscript.m"
#' mypath <- getwd()
#' print(mypath)
#' scriptCode <- "pwd, x=1:2:7; y=3; z=x.^y; save xyz.mat x y z -v7"
#' writeLines(scriptCode, con=scriptName)
#' list.files(mypath)
#' runMatlabScript(scriptName)
#' list.files(mypath)
#' system(paste("rm ", scriptName, sep=""))
#' inp <- R.matlab::readMat("xyz.mat")
#' str(inp)
#' system("rm xyz.mat")
#' list.files(mypath)
#' }
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 13.04.15


runMatlabScript <- function(scriptName){
   #### Checking whether .m was appended to the scriptName ####
   if(!is.na(stringr::str_locate(scriptName, ".m")[[1]])){ # TRUE: '.m' has to be removed
      scriptName <- stringr::str_sub(scriptName, start = 1L, end = -3L)
   }




   #### Selecting Matlab App ####
   si <- Sys.info()

   if (si[["sysname"]]=="Darwin") {
      matl       <- getMacMatlab()
      matlabCall <- paste('/Applications/', matl, '/bin/matlab', sep="")

   } else {
      matlabCall <- 'matlab'
   }




   #### Starting Matlab ####
   mypath <- getwd()
   matlabRun <- paste(matlabCall, " -nosplash -nodesktop -r \"cd ", mypath,
                      "; ", scriptName, "; quit\"", sep="")

   cat(matlabRun)
   system(matlabRun)

}

