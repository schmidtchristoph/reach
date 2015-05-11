#' Converts an eligible Matlab .mat file to an .RData file
#'
#' Converts an eligible Matlab .mat file to an .RData file. Keeps the .mat file unchanged.
#' The Matlab file must have been saved with the -v7 option flag.
#'
<<<<<<< HEAD
#' @param matfile A string denoting the matfile, e.g. "mymatlabdata" or "mymatlabdata.mat"
=======
#' @param matfile string or string vector denoting one or several matfiles, e.g.
#'   "mymatlabdata" or "mymatlabdata.mat" or c("one.mat", "two.mat")
#'
#' @param dir path to a directory which contains one or several .mat files that
#'   should be converted to .RData files
#'
#' @details If single .mat files in the current directory should be converted to
#'   .RData, then the input argument dir has to be set to NULL. If the input
#'   argument matfile is NULL and the input argument dir is specified, then all
#'   .mat files in the given directory will be converted to .RData. If on the
#'   other hand both input arguments, dir and matfile, are specified, then the
#'   given .mat file(s) in the given directory will be converted to .RData.
#'   Providing the file type specifier ".mat" is optional.
>>>>>>> 52af67b... Convert2RData: now all .mat files in user specified directories can be converted. An input vector of .mat files is now accepted for conversion.
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
<<<<<<< HEAD
=======
#' R.matlab::writeMat("dir_convert2RData_1.mat", m=m)
#' R.matlab::writeMat("dir_convert2RData_2.mat", v=v)
#' rm(v,m)
#' convert2RData(dir=this_dir)
#' load("dir_convert2RData_1.Rdata")
#' print(m)
#' load("dir_convert2RData_2.Rdata")
#' print(v)
#'
#' # conversion of a single specified .mat file in a specified directory
#' this_dir <- getwd()
#' v   <- seq(1,10)
#' print(v)
#' R.matlab::writeMat("file_dir_convert2RData.mat", v=v)
#' rm(v)
#' convert2RData("file_dir_convert2RData.mat", this_dir)
#' load("file_dir_convert2RData.RData")
#' print(v)
>>>>>>> 52af67b... Convert2RData: now all .mat files in user specified directories can be converted. An input vector of .mat files is now accepted for conversion.
#'
#' # conversion of several specified .mat files
#' v <- sample(1:10,4)
#' m <- matrix(runif(9),3,3)
#' print(v)
#' print(m)
#' R.matlab::writeMat("twofiles_convert2RData_1.mat", v=v)
#' R.matlab::writeMat("twofiles_convert2RData_2.mat", m=m)
#' rm(v,m)
#' convert2RData(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat"))
#' load("twofiles_convert2RData_1.RData")
#' print(v)
#' load("twofiles_convert2RData_2.RData")
#' print(m)
#'
#' @author Christoph Schmidt <christoph.schmidt@@med.uni-jena.de>

<<<<<<< HEAD
# 27.02.15
=======
# 11.05.15


convert2RData <- function(matfile=NULL, dir=NULL){
   #### file(s) in current directory ####
   if(is.null(dir)){

      if(is.null(matfile)){
         stop("Input argument matfile not specified")
      }


      for(f in 1:length(matfile)){
         matfile_ <- check_matfile_format(matfile[f])


         if(is.na(file.info(matfile_)$size)){
            stop("Wrong input argument matfile. Does not exist in current directory.")
         }


         convertFile(matfile_)
      }





   #### file(s) in a specified directory ####
   } else {
      isDir <- file.info(dir)$isdir

      if(is.na(isDir) || !isDir){
         stop("Wrong input argument dir. Does not exist or is no directory.")
      }


      old_wd <- getwd()
      setwd(dir) # since given directory exists, we can change the working directory to it


      #### convert entire directory ####
      if(is.null(matfile)){
         dirCont <- list.files(pattern="*.mat$")

         if(length(dirCont)==0){
            setwd(old_wd)
            stop("No .mat files found in specified directory.")
         }

>>>>>>> 52af67b... Convert2RData: now all .mat files in user specified directories can be converted. An input vector of .mat files is now accepted for conversion.


convert2RData <- function(matfile){
   ind <- stringr::str_locate(matfile,".mat")
   if(!is.na(ind[1])) matfile <- stringr::str_sub(matfile, 1, ind[1]-1) # file type specifier was provided


   writeLines(paste("Loading", matfile))
   inp <- R.matlab::readMat(paste(matfile, ".mat", sep=""))

<<<<<<< HEAD
=======
      #### convert specified matfile(s) ####
      } else {
         for(f in 1:length(matfile)){
            matfile_ <- check_matfile_format(matfile[f])
>>>>>>> 52af67b... Convert2RData: now all .mat files in user specified directories can be converted. An input vector of .mat files is now accepted for conversion.

   for(k in 1:length(inp)) assign(names(inp)[k], inp[[names(inp)[k]]])

<<<<<<< HEAD
=======
            if(is.na(file.info(matfile_)$size)){
               setwd(old_wd)
               stop("Wrong input argument matfile. Does not exist in specified directory.")
            }


            convertFile(matfile_)
         }

         setwd(old_wd)
      }
   }
}






convertFile <- function(fname){ # fname ends with .mat
   writeLines(paste("Loading...", fname))
   imp <- R.matlab::readMat(fname)


   for(k in 1:length(imp)){
      assign(names(imp)[k], imp[[names(imp)[k]]])
   }


   save(list=names(imp), file = paste(stringr::str_sub(fname, 1, nchar(fname)-4), ".RData", sep=""))
>>>>>>> 52af67b... Convert2RData: now all .mat files in user specified directories can be converted. An input vector of .mat files is now accepted for conversion.

   save(list=names(inp), file = paste(matfile, ".RData", sep=""))
   writeLines("Finished saving corresponding .RData file.")
}

<<<<<<< HEAD
=======





check_matfile_format <- function(fname){
   ind <- stringr::str_locate_all(fname,".mat")[[1]]


   if(nrow(ind)==0){ # file type specifier was not provided (is not contained), thus has to be added
      fname <- paste(fname, ".mat", sep="")


   } else { # see if contained substring ".mat" is situated at the end of the filenname (where it should be)
      isAtEnd <- (ind[nrow(ind), 2]==nchar(fname))

      if(!isAtEnd){
         warning("Input argument string fname contains substring .mat, but not at its end ... appending it.")
         fname <- paste(fname, ".mat", sep="")
      }
   }

   return(fname)
}
>>>>>>> 52af67b... Convert2RData: now all .mat files in user specified directories can be converted. An input vector of .mat files is now accepted for conversion.
