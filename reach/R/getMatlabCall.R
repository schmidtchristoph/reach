#' Get OS-specific Matlab program call string
#'
#' Returns the matlab programm name for OS X, Linux and Windows.
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 03.06.16

getMatlabCall <- function(){
   si     <- Sys.info()
   osName <- si[["sysname"]]

   if(osName=="Darwin"){ # OS X
      matl       <- getMacMatlab()
      matlabCall <- paste("/Applications/", matl, "/bin/matlab", sep="")

   } else if(osName== "Linux" || osName=="Windows"){ # (-: ||  )-:
      matlabCall <- "matlab"


   } else {
      warning("reach::getMatlabCall: Unsupported operating system.")
   }

   return(matlabCall)
}
