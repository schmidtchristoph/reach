library(reach)
library(testthat)
context("Conversion of Matlab .m files to R .RData files")


test_that("convert2RData terminates", {

   ##### conversion of a single .mat file in the current working directory ####
   v <- sample(1:10,4)
   m <- matrix(runif(9),3,3)
   R.matlab::writeMat("file_convert2RData.mat", v=v, m=m)
   expect_that(convert2RData("file_convert2RData.mat"), not(throws_error()))
   suppressWarnings(file.remove(c("file_convert2RData.mat", "file_convert2RData.RData")))



   #### conversion of all .mat files in a specified directory ####
   this_dir <- getwd()
   m   <- matrix(runif(9),3,3)
   v   <- seq(1,100)
   R.matlab::writeMat("dir_convert2RData_1.mat", m=m)
   R.matlab::writeMat("dir_convert2RData_2.mat", v=v)
   expect_that(convert2RData(dir=this_dir), not(throws_error()))
   suppressWarnings(file.remove(c("dir_convert2RData_1.mat", "dir_convert2RData_2.mat",
                                          "dir_convert2RData_1.Rdata", "dir_convert2RData_2.Rdata")))



   #### conversion of all .mat files in the current working directory ####
   m   <- matrix(runif(9),3,3)
   v   <- seq(1,100)
   R.matlab::writeMat("dir_convert2RData_1.mat", m=m)
   R.matlab::writeMat("dir_convert2RData_2.mat", v=v)
   expect_that(convert2RData(), not(throws_error()))
   suppressWarnings(file.remove(c("dir_convert2RData_1.mat", "dir_convert2RData_2.mat",
                                          "dir_convert2RData_1.Rdata", "dir_convert2RData_2.Rdata")))



   #### conversion of a single specified .mat file in a specified directory ####
   this_dir <- getwd()
   v   <- seq(1,10)
   R.matlab::writeMat("file_dir_convert2RData.mat", v=v)
   expect_that(convert2RData("file_dir_convert2RData.mat", this_dir), not(throws_error()))
   suppressWarnings(file.remove(c("file_dir_convert2RData.mat", "file_dir_convert2RData.RData")))



   #### conversion of several specified .mat files in the current working directory ####
   v <- sample(1:10,4)
   m <- matrix(runif(9),3,3)
   R.matlab::writeMat("twofiles_convert2RData_1.mat", v=v)
   R.matlab::writeMat("twofiles_convert2RData_2.mat", m=m)
   expect_that(convert2RData(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat")),
               not(throws_error()))
   suppressWarnings(file.remove(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat",
                                          "twofiles_convert2RData_1.RData", "twofiles_convert2RData_2.RData")))
})







test_that("convert2RData produced output .RData files", {
   testthat::skip_on_travis() # to avoid typical Travis illogical errors

   ##### conversion of a single .mat file in the current working directory ####
   v <- sample(1:10,4)
   m <- matrix(runif(9),3,3)
   R.matlab::writeMat("file_convert2RData.mat", v=v, m=m)
   convert2RData("file_convert2RData.mat")
   bool <- suppressWarnings(file.remove(c("file_convert2RData.mat", "file_convert2RData.RData")))
   expect_equal(bool, c(TRUE, TRUE))



   #### conversion of all .mat files in a specified directory ####
   this_dir <- getwd()
   m   <- matrix(runif(9),3,3)
   v   <- seq(1,100)
   R.matlab::writeMat("dir_convert2RData_1.mat", m=m)
   R.matlab::writeMat("dir_convert2RData_2.mat", v=v)
   convert2RData(dir=this_dir)
   bool <- suppressWarnings(file.remove(c("dir_convert2RData_1.mat", "dir_convert2RData_2.mat",
                                          "dir_convert2RData_1.Rdata", "dir_convert2RData_2.Rdata")))
   expect_equal(bool, c(TRUE, TRUE, TRUE, TRUE))



   #### conversion of all .mat files in the current working directory ####
   m   <- matrix(runif(9),3,3)
   v   <- seq(1,100)
   R.matlab::writeMat("dir_convert2RData_1.mat", m=m)
   R.matlab::writeMat("dir_convert2RData_2.mat", v=v)
   convert2RData()
   bool <- suppressWarnings(file.remove(c("dir_convert2RData_1.mat", "dir_convert2RData_2.mat",
                                          "dir_convert2RData_1.Rdata", "dir_convert2RData_2.Rdata")))
   expect_equal(bool, c(TRUE, TRUE, TRUE, TRUE))



   #### conversion of a single specified .mat file in a specified directory ####
   this_dir <- getwd()
   v   <- seq(1,10)
   R.matlab::writeMat("file_dir_convert2RData.mat", v=v)
   convert2RData("file_dir_convert2RData.mat", this_dir)
   bool <- suppressWarnings(file.remove(c("file_dir_convert2RData.mat", "file_dir_convert2RData.RData")))
   expect_equal(bool, c(TRUE, TRUE))



   #### conversion of several specified .mat files in the current working directory ####
   v <- sample(1:10,4)
   m <- matrix(runif(9),3,3)
   R.matlab::writeMat("twofiles_convert2RData_1.mat", v=v)
   R.matlab::writeMat("twofiles_convert2RData_2.mat", m=m)
   convert2RData(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat"))
   bool <- suppressWarnings(file.remove(c("twofiles_convert2RData_1.mat", "twofiles_convert2RData_2.mat",
                                          "twofiles_convert2RData_1.RData", "twofiles_convert2RData_2.RData")))
   expect_equal(bool, c(TRUE, TRUE, TRUE, TRUE))
})








test_that("a wrong directory input results in an error", {
   this_dir <- paste(getwd(), "/nonsenseDir2", sep = "")
   expect_error(convert2RData(dir = this_dir), regexp = "Wrong input argument dir. Does not exist or is no directory.")
})
