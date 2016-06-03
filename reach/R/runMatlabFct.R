#' Runs a Matlab function like an R function and returns its results
#'
#' Runs Matlab on the R console, evaluates the specified Matlab function with
#' given arguments and directly returns the Matlab output as a single value or a
#' list of values back to the R session. The function acts as a proxy for the
#' specified Matlab function. It handles all Matlab related things internally
#' and transparently to the user and just returns the specified Matlab output
#' arguments as results of the computations performed by Matlab.
#'
#' @note For starting several Matlab functions independently of each other, or a
#'   chain of Matlab functions, consider using the 'runMatlabCommand()'
#'   function, or writing a Matlab script file and use the 'runMatlabScript()'
#'   function and store the results in a .mat file that can be read back into R
#'   with the help of the 'convert2RData()' function.
#'
#' @param fcall string specifying the Matlab function call with output and input
#'   parameters, just as one would call the function inside a regular Matlab
#'   session. The input arguments specified in fcall must be variable names
#'   stored in the current R session (the environment where the function was
#'   called from) or numeric values. Variable names are preferred and should be
#'   the standard for using this function. If no output parameter are contained
#'   in fcall, then it is assumed that the user expects Matlab to not
#'   automatically quit (e.g. because the function call was a plotting function
#'   and the plot window should stay open). In this case the Matlab process has
#'   to be terminated manually (!) by the user before the function can terminate
#'   and one can continue to work in the R session. Nested Matlab function calls
#'   (function as input argument for a function) are currently not supported.
#'
#' @return The results of the Matlab function call. A list of named entries that
#'   correspond to the output arguments of the Matlab function as specified in
#'   \emph{fcall}.
#'
#' @details This function calls the user specified Matlab function and manages
#'   the necessary data exchange transparently, thus providing a seamless
#'   experience. The data is exchanged robustly over the file system, using
#'   temporary files that will be deleted automatically.
#'
#' @seealso \code{\link{runMatlabScript}}, \code{\link{runMatlabCommand}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' a       <- c(1,2,1,4,1,5,4,3,2,2,1,6,3,1,3,5,5)
#' b       <- c(4,6,9)
#' fcall   <- "[bool, pos] = ismember(b,a)"
#'
#' results <- runMatlabFct(fcall)
#'
#' bool    <- results$bool
#' pos     <- results$pos
#' print(a)
#' print(b)
#' print(fcall)
#' print(bool)
#' print(pos)
#'
#'
#'
#' # !the Matlab process has to be terminated manually!
#' runMatlabFct("image")
#'
#'
#'
#' # !the Matlab process has to be terminated manually!
#' # wrong Matlab function input ( it should be penny or penny() ), but corrected internally
#' runMatlabFct("penny(")
#'
#'
#'
#' M       <- matrix(c(2,-1,0,  -1,2,-1,  0,2,3), 3, 3)
#' fcall   <- "C = chol(M)"
#' results <- runMatlabFct(fcall)
#' print(results)
#'
#'
#'
#' A  <- runMatlabFct("A=rand(6)")$A
#' A_ <- runMatlabFct("A_=inv(A)")$A_
#' print(round(A %*% A_))
#'
#'
#'
#' nu_  <- 0.32
#' vec_ <- c(1,2,5,2,6)
#' res_ <- runMatlabFct("v_ = bessely(nu_, vec_)")
#' print(res_$v_)
#'
#'
#'
#' orig_str <- 'this_test_was_my_first_test'
#' old_sub  <- 'test'
#' new_sub  <- 'assignment'
#' new_str  <- runMatlabFct('str=strrep(orig_str, old_sub, new_sub)')
#' print(new_str$str)
#'
#' }
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 03.06.16

runMatlabFct <- function(fcall){
   ### Avoid problems when input has no parentheses---
   if(!stringr::str_detect(fcall, "\\(" )){
      fcall <- stringr::str_replace_all(fcall, "\\)", "")
      fcall <- stringr::str_c(fcall, "()")
   }


   if(!stringr::str_detect(fcall, "\\)" )){
      fcall <- stringr::str_replace_all(fcall, "\\(", "")
      fcall <- stringr::str_c(fcall, "()")
   }






   ### Parsing fct call - extract input arguments (strings)---
   ind1   <- stringr::str_locate(fcall, "\\(")[1,1]
   ind2   <- stringr::str_locate_all(fcall, "\\)")[[1]] # should be the last position in the string (or second last if at the last position is an ';')
   ind2   <- ind2[dim(ind2)[1], 1]
   fcall_ <- stringr::str_sub(fcall, ind1+1, ind2-1)
   inp    <- str_extractCommaSepArgs(fcall_)






   # input args with the same name as writeMat() options, like 'verbose', cannot be written to tmp_1 .mat file
   if(any(c("verbose", "con", "matVersion", "onWrite") %in% inp)){
      stop(paste("\nInput arguments have names incompatible with internal call to the 'writeMat()' function.\n",
                 "'verbose, 'con', 'matVersion' and 'onWrite' are not allowed.", sep = ""))
   }






   ### Parsing fct call - extract output arguments---
   if(stringr::str_detect(fcall, "\\[")){
      ind1   <- stringr::str_locate_all(fcall, "\\[")[[1]] # should be the last position in the string (or second last if at the last position is an ';')
      ind1   <- ind1[dim(ind1)[1], 1]
      ind2   <- stringr::str_locate(fcall, "\\]")[1,1]

   } else {
      ind1   <- 0
      ind2   <- stringr::str_locate(fcall, "=")[1,1]
   }

   fcall_ <- stringr::str_sub(fcall, ind1+1, ind2-1)
   out    <- str_extractCommaSepArgs(fcall_)







   ### checking whether output arguments have to be changed/ substituted due to symbols incompatible with R.matlab readMat()---
   if( is.na(out[[1]]) ){ out_present <- FALSE } else { out_present <- TRUE }


   if(out_present){ # if output args were specified
      out_orig <- out
      ind_repl <- 1
      pattern  <- "[_-]"

      for(k in 1:length(out)){
         thisarg   <- out[[k]]

         if( stringr::str_detect(thisarg, pattern) ){
            out[[k]] <- stringr::str_replace_all(thisarg, pattern, as.character(ind_repl))
            fcall    <- stringr::str_replace_all(fcall, out_orig[[k]], out[[k]])
            ind_repl <- ind_repl + 1
         }
      }
   }









   ### Check if input arguments are available in the environment where the function was called from---
   itswin <- isWin()
   tmp_2  <- tempfile("rmf_", getwd(), ".mat")
   if(itswin){ tmp_2  <- stringr::str_replace_all(tmp_2, "\\\\", "/") } # adjusting path specificatin for Windows

   if( !identical(inp[[1]], "") ){ inp_present <- TRUE } else { inp_present <- FALSE }

   if(inp_present){ # only if input is specified (and is a workspace variable name), the 1st temporary file tmp_1 is written & the Matlab command generated
      tmp_1            <- tempfile("rmf_", getwd(), ".mat")
      if(itswin){ tmp_1 <- stringr::str_replace_all(tmp_1, "\\\\", "/") }
      wM               <- paste("matWrite(\"", tmp_1, "\", \"", sep = "") #writeMat() / matWrite() command
      any_var_in_envir <- FALSE

      for(k in 1:length(inp)){
         if( exists(inp[[k]], envir = parent.frame()) ){ var_in_envir <- TRUE } else { var_in_envir <- FALSE } # parent.frame() returns the environment where the function was called from


         if( !is.na(suppressWarnings(as.double(inp[[k]]))) ){ var_is_num <- TRUE } else { var_is_num <- FALSE } # input was a numeric, e.g. "A=rand(16)"


         if( !var_in_envir && !var_is_num ){
               stop(paste("Matlab input argument (given in fcall) does not exist:", inp[[k]]))
         }


         if( var_in_envir ){
            any_var_in_envir <- TRUE
            assign( inp[[k]], get(inp[[k]], envir = parent.frame()) )
            wM               <- paste(wM, paste(inp[[k]], ", ", sep = ""))
         }
      } # for 1:length(inp)


      if( any_var_in_envir ){
         wM    <- stringr::str_sub(wM, end = -3L)
         wM    <- paste(wM, "\")", sep = "")
         eval(parse(text=wM)) # writing tmp_1
         thisc <- paste("load ", tmp_1, "; ", fcall, "; save('", tmp_2, "', '-v7')", sep = "") # Matlab command
      }
   } # inp_present


   if( !inp_present || !any_var_in_envir) { # input is not specified or is a numeric value (not a variable name), so no tmp_1 .mat file was written, hence it cannot be loaded
      thisc <- paste(fcall, "; save('", tmp_2, "', '-v7')", sep = "")
   }








   ### call to Matlab function---
   if(out_present){ # if output args are specified, then Matlab should quit, otherwise not
      reach::runMatlabCommand(thisc, verbose = FALSE, do_quit = TRUE) # Matlab quits automatically

   } else {
      reach::runMatlabCommand(thisc, verbose = FALSE, do_quit = FALSE)
   }




   if(itswin){
      Sys.sleep(4) # for Windows only, wait until Matlab finished the computations - since Matlab process is separated from the running R session
      while(TRUE){
         if(file.exists(tmp_2)){
            break

         } else {
            Sys.sleep(1.5)
         }
      }
   }





   ### Read back the results of the computation, delete all temporary files, return results---
   if(out_present){
      res        <- R.matlab::readMat(tmp_2)
      res        <- res[unlist(out)]
      names(res) <- out_orig
   } else {
      res        <- "(-:"
   }


   if( inp_present && any_var_in_envir ){
      file.remove(c(tmp_1, tmp_2))

   } else {
      file.remove(tmp_2)
   }


   return(res)
}
