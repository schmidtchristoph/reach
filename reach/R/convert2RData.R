#' Converts a Matlab data file (.mat) to R data file (.RData)
#'
#' Converts all or specified Matlab .mat files in the specified directory to
#' .RData files, while keeping the .mat files unchanged. The Matlab files must
#' have been saved in a MAT file format version supported by R.matlab's
#' \code{readMat} function (e.g. saved with the -v7 option flag, but not with
#' the -v7.3 flag).
#'
#' @param matfile character or character vector denoting one or several
#'   matfiles, e.g. "mymatlabdata", "mymatlabdata.mat", c("one.mat", "two.mat").
#'   Providing the file type specifier ".mat" is optional. Defaults to NULL,
#'   which means that all .mat files in the specified directory \code{dir} will
#'   be converted.
#'
#' @param dir path to a directory which contains one or several .mat files that
#'   should be converted to .RData files. Defaults to the current working
#'   directory.
#'
#' @param verbose logical indicating whether console output about the conversion
#'   process should be printed
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' ##### conversion: specified .mat file in current working directory ####
#' v <- sample(1:10,4)
#' m <- matrix(runif(9),3,3)
#' R.matlab::writeMat("file_convert2RData.mat", v=v, m=m)
#' rm(v,m)
#' convert2RData("file_convert2RData.mat")
#' load("file_convert2RData.RData")
#' print(v)
#' print(m)
#' file.remove(c("file_convert2RData.RData", "file_convert2RData.mat"))
#'
#'
#'
#' #### conversion: all .mat files in a specified directory ####
#' this_dir <- getwd()
#' m   <- matrix(runif(9),3,3)
#' v   <- seq(1,100)
#' R.matlab::writeMat("dir_convert2RData_1.mat", m=m)
#' R.matlab::writeMat("dir_convert2RData_2.mat", v=v)
#' rm(v,m)
#' convert2RData(dir = this_dir, verbose = TRUE)
#' load(paste(this_dir, "/dir_convert2RData_1.Rdata", sep = ""))
#' print(m)
#' load(paste(this_dir, "/dir_convert2RData_2.Rdata", sep = ""))
#' print(v)
#' file.remove(c(paste(this_dir, "/dir_convert2RData_1.mat", sep = ""),
#'    paste(this_dir, "/dir_convert2RData_2.mat", sep = ""),
#'    paste(this_dir, "/dir_convert2RData_1.Rdata", sep = ""),
#'    paste(this_dir, "/dir_convert2RData_2.Rdata", sep = "")))
#'
#'
#'
#' #### conversion: specified .mat file in a specified directory ####
#' this_dir <- getwd()
#' v   <- seq(1,10)
#' R.matlab::writeMat("file_dir_convert2RData.mat", v=v)
#' rm(v)
#' convert2RData("file_dir_convert2RData.mat", this_dir)
#' load("file_dir_convert2RData.RData")
#' print(v)
#' file.remove(c("file_dir_convert2RData.mat", "file_dir_convert2RData.RData"))
#'
#'
#'
#' #### conversion: several specified .mat files in current working directory ####
#' v <- sample(1:10,4)
#' m <- matrix(runif(9),3,3)
#' R.matlab::writeMat("twofiles_convert2RData_1.mat", v=v)
#' R.matlab::writeMat("twofiles_convert2RData_2.mat", m=m)
#' rm(v,m)
#' convert2RData(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat"))
#' load("twofiles_convert2RData_1.RData")
#' print(v)
#' load("twofiles_convert2RData_2.RData")
#' print(m)
#' file.remove(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat",
#'    "twofiles_convert2RData_1.RData", "twofiles_convert2RData_2.RData"))
#' }
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

# 19.12.15


convert2RData <- function(matfile = NULL, dir = "./", verbose = FALSE){

   isDir <- file.info(dir)$isdir

   if(is.na(isDir) || !isDir){
      stop("Wrong input argument dir. Does not exist or is no directory.")
   }



   if(dir != "./"){
      old_wd <- getwd()
      setwd(dir)
   }



   if(is.null(matfile)){ # convert all .mat files in dir
      dirCont <- list.files(pattern="*.mat$")

      if(length(dirCont)==0){
         if(dir != "./"){
            setwd(old_wd)
         }
         stop("No .mat files found in specified directory.")
      }


      for(f in 1:length(dirCont)){
         if(verbose){
            writeLines("")
            writeLines(paste("Conversion file #", f, " - ", dirCont[f]))
         }
         convertFile(dirCont[f], verbose)
      }
   }
   else { # convert specific .mat files in dir
      for(f in 1:length(matfile)){
         matfile_ <- check_matfile_format(matfile[f])

         if(is.na(file.info(matfile_)$size)){
            if(dir != "./"){
               setwd(old_wd)
            }
            stop(paste("Specified matfile #: ", f, "\n\t", matfile[f], "\ndoes not exist in specified directory.", sep = ""))
         }

         convertFile(matfile_, verbose)
      }

   }


   if(dir != "./"){
      setwd(old_wd)
   }
}





# Converts a .mat file to a .RData file
convertFile <- function(fname, verbose){ # fname ends with .mat
   if(verbose){
      writeLines(paste("Loading...", fname))
   }

   matCont <- R.matlab::readMat(fname)


   for(k in 1:length(matCont)){
      assign(names(matCont)[k], matCont[[names(matCont)[k]]])
   }


   save(list=names(matCont), file = paste(stringr::str_sub(fname, 1, nchar(fname)-4), ".RData", sep=""))

   if(verbose){
      writeLines("Finished saving corresponding .RData file.")
   }
}






# Checks whether the .mat file name ends with '.mat' and if necessary appends this suffix to the file name
check_matfile_format <- function(fname){
   if(!stringr::str_detect(stringr::str_sub(fname, -4L, -1L), ".mat")){
      fname <- paste(fname, ".mat", sep = "") # works even if fname ends with '.', or contains '.mat' somewhere different from its end
   }

   return(fname)
}
