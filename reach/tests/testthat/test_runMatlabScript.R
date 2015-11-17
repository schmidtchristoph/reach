library(testthat)


context("runMatlabScript")




test_that("throws an error if input script is not present in working directory before Matlab does", {
   expect_error(runMatlabScript("MYSCRIPT2.m"), "Input Matlab script does not exist in current working directory.")


   expect_error(runMatlabScript("noscript.m"), "Input Matlab script does not exist in current working directory.")


   expect_error(runMatlabScript("noscript"), "Input Matlab script does not exist in current working directory.")


   scriptName <- "myscript.m"
   scriptCode <- "x=1:2:7; y=3; z=x.^y; save xyz.mat x y z -v7"
   writeLines(scriptCode, con=scriptName)
   expect_that(runMatlabScript("myscript"), not(throws_error()))
   expect_that(runMatlabScript("myscript.m"), not(throws_error()))


   file.remove("myscript.m")
   file.remove("xyz.mat")
})







test_that("calling Matlab yields correct results", {
   scriptName <- "myscript.m"
   scriptCode <- "x=1:2:7; y=3; z=x.^y; M = magic(4); M3 = M^3; save TesT.mat x y z M M3 -v7"
   writeLines(scriptCode, con=scriptName)
   expect_that(runMatlabScript("myscript.m"), not(throws_error()))
   inp <- R.matlab::readMat("TesT.mat")

   x  <- seq(1, 7, 2)
   y  <- 3
   z  <- x^y
   M  <- structure(c(16, 5, 9, 4, 2, 11, 7, 14, 3, 10, 6, 15, 13, 8, 12, 1), .Dim = c(4L, 4L)) # M <- dput(matlab::magic(4))
   M3 <- M %*% M %*% M

   expect_equal(x, as.vector(inp$x))
   expect_equal(y, as.vector(inp$y))
   expect_equal(z, as.vector(inp$z))
   expect_equal(M, inp$M)
   expect_equal(M3, inp$M3)

   file.remove("myscript.m")
   file.remove("TesT.mat")
})
