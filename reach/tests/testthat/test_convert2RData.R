library(reach)

context("Conversion of Matlab .m files to R .RData files")


test_that("convert2RData terminates", {

   ##### conversion of a single .mat file in the current working directory ####
   v <- sample(1:10,4)
   m <- matrix(runif(9),3,3)
   R.matlab::writeMat("file_convert2RData.mat", v=v, m=m)

   expect_that(invisible(capture.output(convert2RData("file_convert2RData.mat"))), not(throws_error()))

   invisible(capture.output(file.remove(c("file_convert2RData.mat", "file_convert2RData.RData"))))



   #### conversion of all .mat files in a specified directory ####
   this_dir <- getwd()
   m   <- matrix(runif(9),3,3)
   v   <- seq(1,100)
   R.matlab::writeMat("dir_convert2RData_1.mat", m=m)
   R.matlab::writeMat("dir_convert2RData_2.mat", v=v)

   expect_that(invisible(capture.output(convert2RData(dir=this_dir))), not(throws_error()))

   invisible(capture.output(file.remove(c("dir_convert2RData_1.mat", "dir_convert2RData_2.mat",
                                          "dir_convert2RData_1.Rdata", "dir_convert2RData_2.Rdata"))))



   #### conversion of a single specified .mat file in a specified directory ####
   this_dir <- getwd()
   v   <- seq(1,10)
   R.matlab::writeMat("file_dir_convert2RData.mat", v=v)

   expect_that(invisible(capture.output(convert2RData("file_dir_convert2RData.mat", this_dir))), not(throws_error()))

   invisible(capture.output(file.remove(c("file_dir_convert2RData.mat", "file_dir_convert2RData.RData"))))



   #### conversion of several specified .mat files in the current working directory ####
   v <- sample(1:10,4)
   m <- matrix(runif(9),3,3)
   R.matlab::writeMat("twofiles_convert2RData_1.mat", v=v)
   R.matlab::writeMat("twofiles_convert2RData_2.mat", m=m)

   expect_that(invisible(capture.output(convert2RData(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat")))),
               not(throws_error()))

   invisible(capture.output(file.remove(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat",
                                          "twofiles_convert2RData_1.RData", "twofiles_convert2RData_2.RData"))))





})
