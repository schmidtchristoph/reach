#' Is the underlying OS Windows?
#'
#' Returns a logical that indicates whether \pkg{reach} is used on a Windows
#' machine (which is useful information for adjusting path specifications).
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 03.06.16
isWin <- function(){
   si     <- Sys.info()
   osName <- si[["sysname"]]

   if(osName=="Windows"){
      return(TRUE)

   } else {
      return(FALSE)
   }
}
