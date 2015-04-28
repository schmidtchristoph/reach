#' Starts Matlab on the R console and executes the input command
#'
#' Starts Matlab on the R console and executes the input command and quits Matlab.
#' Discerns the Mac and Linux Matlab command.
#'
#' @param commandName String denoting the matlab command
#'
#' @details As R and Matlab cannot directly exchange data natively, no value can be returned.
#' Instead, let Matlab save the results of its computations and load these into R for further processing.
#' An error in the Matlab command prevents Matlab from quitting in the R console and might
#' require an re-start of the R session. So check the command in Matlab before executing it within R.
#' The commandName could look something like this:
#' "'load someData.mat; [ca,Q]=modularity_dir(A); save someData2.mat ca Q; quit'"
#'
#' @seealso \code{\link{convert2RData}}, \code{\link{runMatlabScript}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' commandName <- "'x=1:2:7; y=3; disp(x.^y); quit'"
#' runMatlabCommand(commandName)
#' }
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 13.04.15

runMatlabCommand <- function(commandName){
   #### Checking whether the commandName contains enclosing ' and ' ####
   ind <- stringr::str_locate_all(commandName,"'")

   if(length(ind[[1]])==0){
      commandName <- paste("'", commandName, "'", sep="")
   }






   #### Checking whether 'quit' has to be appended ####
   ind <- stringr::str_locate(commandName, "quit") # NA if 'quit' is not included

   if(is.na(ind[[1]])){
      commandName <- paste(stringr::str_sub(commandName, start = 1L, end = -2L), "quit'")
   }




   #### Selecting Matlab call ####
   si <- Sys.info()

   if (si[['sysname']]=='Darwin') {
      matl       <- getMacMatlab()
      matlabCall <- paste('/Applications/', matl, '/bin/matlab', sep="")


   } else {
      matlabCall <- 'matlab'
   }



   flags <- ' -nosplash -nodesktop -r '

   system(paste(matlabCall, flags, commandName, sep=""))
}

