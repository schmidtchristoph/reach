library(testthat)
library(reach)
context("matWrite")


test_that("atomic vectors are transposed and properly imported into Matlab", {
   testthat::skip_on_travis()

   vec  <- sample(100, 13) # 1x13, dim(vec) = NULL >>> atomic vectors don't have dimensions, arrays do
   matWrite("testthat.mat", "vec")
   inp  <- R.matlab::readMat("testthat.mat") # vec is transformed to an array
   vec2 <- inp$vec

   expect_equal(length(vec), dim(vec2)[2])

   script <- "load testthat.mat;\nthisSize = num2str(size(vec));\nsave testthat_back.mat thisSize;"
   writeLines(script, con = "script.m")
   reach::runMatlabScript("script.m")

   inp2     <- R.matlab::readMat("testthat_back.mat")
   thisSize <- inp2$thisSize

   expect_equal(as.vector(thisSize), "1  13")




   vec  <- t(sample(100, 6)) # "vector": t(1x6) = 6x1, but is transformed to an ARRAY (is.vector(vec) = FALSE): dim(vec) = 1 6
   matWrite("testthat.mat", "vec") # the array vec will be written correctly by R.matlab::writeMat() anyway & will not be transposed, too...
   inp  <- R.matlab::readMat("testthat.mat")
   vec2 <- inp$vec

   expect_equal(length(vec), dim(vec2)[2])

   script <- "load testthat.mat;\nthisSize = num2str(size(vec));\nsave testthat_back.mat thisSize;"
   writeLines(script, con = "script.m")
   reach::runMatlabScript("script.m")

   inp2     <- R.matlab::readMat("testthat_back.mat")
   thisSize <- inp2$thisSize

   expect_equal(as.vector(thisSize), "1  6")



   unlink(c("testthat.mat", "testthat_back.mat", "script.m"))
})





test_that("one-dimensional matrices ('vectors') are properly imported to Matlab", {
   testthat::skip_on_travis()

   vec  <- matrix(c(33, 12, 66, 88, 55), 1, 5) # is.array(vec) = TRUE, is.vector(vec) = FALSE >>> so no change (t()) made by matWrite()
   matWrite("testthat.mat", "vec")
   inp  <- R.matlab::readMat("testthat.mat")
   vec2 <- inp$vec

   expect_equal(dim(vec), dim(vec2))

   script <- "load testthat.mat;\nthisSize = num2str(size(vec));\nsave testthat_back.mat thisSize;"
   writeLines(script, con = "script.m")
   reach::runMatlabScript("script.m")

   inp2     <- R.matlab::readMat("testthat_back.mat")
   thisSize <- inp2$thisSize

   expect_equal(as.vector(thisSize), "1  5")





   vec  <- matrix(c(33, 12, 66, 88, 55), 5, 1) # is.array(vec) = TRUE, is.vector(vec) = FALSE >>> so no change (t()) made by matWrite()
   matWrite("testthat.mat", "vec")
   inp  <- R.matlab::readMat("testthat.mat")
   vec2 <- inp$vec

   expect_equal(dim(vec), dim(vec2))

   script <- "load testthat.mat;\nthisSize = num2str(size(vec));\nsave testthat_back.mat thisSize;"
   writeLines(script, con = "script.m")
   reach::runMatlabScript("script.m")

   inp2     <- R.matlab::readMat("testthat_back.mat")
   thisSize <- inp2$thisSize

   expect_equal(as.vector(thisSize), "5  1")


   unlink(c("testthat.mat", "testthat_back.mat", "script.m"))
})





test_that("logicals are replaced by 0/1 and properly imported to Matlab", {
   testthat::skip_on_travis()

   isTrue  <- TRUE
   notTrue <- FALSE
   matWrite("yxc.mat", "isTrue, notTrue")
   inp      <- R.matlab::readMat("yxc.mat")
   isTrue2  <- inp$isTrue
   notTrue2 <- inp$notTrue

   expect_true(isTrue2 == 1)
   expect_true(notTrue2 == 0)

   script <- "load yxc.mat;\nisTrue3 = isTrue;\nnotTrue3 = notTrue;\nsave yxcb.mat isTrue3 notTrue3;"
   writeLines(script, con = "script.m")
   reach::runMatlabScript("script.m")

   inp2     <- R.matlab::readMat("yxcb.mat")
   isTrue3  <- inp2$isTrue3
   notTrue3 <- inp2$notTrue3

   expect_true(as.vector(isTrue3) == 1)
   expect_true(as.vector(notTrue3) == 0)

   unlink(c("yxc.mat", "yxcb.mat", "script.m"))
})






test_that("non-reformated variables are properly saved and imported to Matlab", {
   testthat::skip_on_travis()

   A    <- matrix(c(2,3,4,2, 1,1,2,6, 8,3,9,7), 3, 4, byrow = TRUE)
   matWrite("testthat.mat", "A")
   inp  <- R.matlab::readMat("testthat.mat")
   A2 <- inp$A

   expect_equal(dim(A), dim(A2))
   expect_identical(A, A2)

   script <- "load testthat.mat;\nthisSize = num2str(size(A));\nsave testthat_back.mat thisSize;"
   writeLines(script, con = "script.m")
   reach::runMatlabScript("script.m")

   inp2     <- R.matlab::readMat("testthat_back.mat")
   thisSize <- inp2$thisSize

   expect_equal(as.vector(thisSize), "3  4")

   unlink(c("testthat.mat", "testthat_back.mat", "script.m"))
})
