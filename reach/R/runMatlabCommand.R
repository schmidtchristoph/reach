#' Starts Matlab on the R console and executes one or several input Matlab
#' commands
#'
#' Starts Matlab on the R console and let it executes the input Matlab command
#' or several input commands, like function calls (separated by ";") and quits
#' Matlab. No values are directly returned back to the R session. To achieve
#' this, use the function 'runMatlabFct()'. Discerns the OS X and Linux Matlab
#' app shell command. Automatically changes to the current R working directory
#' in Matlab so that .mat files with Matlab results would be saved there instead
#' of the default Matlab working directory.
#'
#' @param commandName a string denoting the Matlab command/ commands
#'
#' @param verbose logical indicating if the final internally generated Matlab
#'   command should be printed to the R console
#'
#' @param do_quit logical indicating if the Matlab process should quit itself.
#'   The default is TRUE, however, if the Matlab command is a plot function then
#'   one wants Matlab to keep displaying the plot window and not quit. This
#'   means the user has to quit Matlab manually prior to continue working in the
#'   current R session.
#'
#' @details As R and Matlab cannot directly exchange data natively, no value can
#'   be returned. Instead, let Matlab save the results of its computations and
#'   load these into R for further processing. An error in the Matlab command
#'   prevents Matlab from quitting in the R console and might require killing
#'   the Matlab process or an re-start of the R session. (You migth want to
#'   check the command in Matlab before executing it within R.) The commandName
#'   could look something like this: "load someData.mat; [out1,
#'   out2]=someMatlabFunction(in1, in2, in3); save someData2.mat; quit"
#'
#' @seealso \code{\link{runMatlabFct}}, \code{\link{runMatlabScript}}
#'
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' commandName <- "x=1:2:7; y=3; disp(x); disp(x.^y); quit"
#' runMatlabCommand(commandName)
#'
#'
#'
#' commandName2 <- "M=magic(4); disp(M); eig(M)"
#' runMatlabCommand(commandName2)
#'
#'
#'
#' wrong_but_corrected_commandName <- "M=magic(4); disp(M); eig(M) quit"
#' runMatlabCommand(wrong_but_corrected_commandName)
#'
#'
#'
#' commandName3 <- "A=magic(3); save('magic.mat', 'A', '-v7'); quit"
#' runMatlabCommand(commandName3)
#' input        <- R.matlab::readMat("magic.mat")
#' print(input$A)
#' invisible(capture.output(file.remove("magic.mat")))
#'
#'
#'
#' # !the Matlab process has to be terminated manually!
#' commandName4 <- "A=magic(40); imagesc(A)"
#' runMatlabCommand(commandName4, do_quit = FALSE)
#'
#'
#'
#' # !the Matlab process has to be terminated manually!
#' commandName4 <- "spy; quit" # quit will be internally removed
#' runMatlabCommand(commandName4, do_quit = FALSE)
#'
#' }
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 01.10.15

runMatlabCommand <- function(commandName, verbose = FALSE, do_quit = TRUE){

   #### Checking whether 'quit' has to be appended to commandName ####
   has_quit <- stringr::str_detect(commandName, "quit")

   if(do_quit){
      if(!has_quit){
         commandName <- stringr::str_c(commandName, " ,;quit")

      } else { # ensure Matlab really quits: add ",;" directly preceding "quit" in case neither "," or ";" was put in front of "quit"
         ind2        <- stringr::str_locate(commandName, "quit")
         tmp1        <- stringr::str_sub(commandName, 1, ind2[1,1]-1)
         tmp2        <- stringr::str_sub(commandName, ind2[1,1], stringr::str_length(commandName))
         commandName <- stringr::str_c(tmp1, ",;", tmp2)
      }

   } else {
   #### Checking whether 'quit' has to be removed from the Matlab command ####
      if(has_quit){
         ind         <- stringr::str_locate(commandName, "quit")
         commandName <- stringr::str_sub(commandName, 1, ind[1]-1)
      }
   }



   #### Checking whether the commandName ends with \" (if not, then appending it) ####
   lastChar  <- stringr::str_sub(commandName, stringr::str_length(commandName), stringr::str_length(commandName))

   if(!identical(lastChar, "\"")){
      commandName <- stringr::str_c(commandName, "\"")
   }



   #### overriding Matlab default working directory ####
   wd          <- getwd()
   commandName <- stringr::str_c("\"cd ", wd, "; ", commandName)



   #### Selecting Matlab call ####
   si <- Sys.info()

   if (si[['sysname']]=='Darwin') {
      matl       <- getMacMatlab()
      matlabCall <- paste('/Applications/', matl, '/bin/matlab', sep="")


   } else {
      matlabCall <- 'matlab'
   }



   flags      <- ' -nosplash -nodesktop -r '
   systemcall <- paste(matlabCall, flags, commandName, sep="")


   if(verbose){ print(systemcall) }


   system(systemcall)
}

