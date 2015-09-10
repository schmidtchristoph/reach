library(reach)

context("Running Matlab commands from the R shell")

test_that("runMatlabCommand terminates", {
   testthat::skip_on_travis() # since Travis CI has no MATLAB installed tests are going to fail there

   commandName <- "x=1:2:7; y=3; disp(x); disp(x.^y); quit"
   expect_that(runMatlabCommand(commandName), not(throws_error()))


   commandName2 <- "M=magic(4); disp(M); eig(M)"
   expect_that(runMatlabCommand(commandName2), not(throws_error()))


   commandName3 <- "M=magic(4); disp(M); eig(M),"
   expect_that(runMatlabCommand(commandName3), not(throws_error()))


   commandName4 <- "M=magic(4); disp(M); eig(M);"
   expect_that(runMatlabCommand(commandName4), not(throws_error()))


   wrong_but_corrected_commandName <- "M=magic(4); disp(M); eig(M) quit"
   expect_that(runMatlabCommand(wrong_but_corrected_commandName), not(throws_error()))


   commandName3 <- "A=magic(3); save('magic.mat', 'A', '-v7'); quit"
   expect_that(runMatlabCommand(commandName3), not(throws_error()))
   input        <- R.matlab::readMat("magic.mat")
   print(input$A)
   A <- structure(c(8, 3, 4, 1, 5, 9, 6, 7, 2), .Dim = c(3L, 3L))
   expect_equal(A, input$A)
   invisible(capture.output(file.remove("magic.mat")))
})
