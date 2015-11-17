library(reach)
library(testthat)

context("Evaluating Matlab functions within R")

test_that("runMatlabFct terminates", {
   testthat::skip_on_travis() # since Travis CI has no MATLAB installed tests would fail there


   a       <- c(1,2,1,4,1,5,4,3,2,2,1,6,3,1,8,3,5,5)
   b       <- c(4,6,9,8)
   fcall   <- "[bool, pos] = ismember(b,a)"
   expect_that(runMatlabFct(fcall), not(throws_error()))



   M     <- matrix(c(2,-1,0,  -1,2,-1,  0,2,3), 3, 3)
   fcall <- "C = chol(M)"
   expect_that(runMatlabFct(fcall), not(throws_error()))



   expect_that(runMatlabFct("h=image()"), not(throws_error()))



   x <- seq(1, 2.5*pi, 0.01)
   y <- (sin(x))^4
   expect_that(runMatlabFct("h   =  plot( x , y   )"), not(throws_error()))



   expect_that(runMatlabFct("A=rand(16)"), not(throws_error()))



   orig_str <- 'this_test_was_my_first_test'
   old_sub  <- 'test'
   new_sub  <- 'assignment'
   expect_that(runMatlabFct('str=strrep(orig_str, old_sub, new_sub)'), not(throws_error()))



   expect_that(out <- runMatlabFct("out=matlab_test_fct_1(11, 22, 33, 44, 55, 66, 777, 8888)"), not(throws_error()))



   expect_that(out <- runMatlabFct("[a,bbb,c_,d-,e_e,f,gG]=matlab_test_fct_2(3)"), not(throws_error()))



   val_ <- -9
   expect_that(out <- runMatlabFct("[a,b,c,d,e,f,g]=matlab_test_fct_3(2, -3, 44, 5, val_)"), not(throws_error()))



   val_ <- -9
   expect_that(out <- runMatlabFct("[a,b]=matlab_test_fct_3(-3, val_)"), not(throws_error()))



   val_ <- -9
   expect_that(out <- runMatlabFct("[a,b,c]=matlab_test_fct_3(-3, val_, 4)"), not(throws_error()))





   val2 <- 12
   expect_that(out <- runMatlabFct("[a,b,c]=matlab_test_fct_3(val_, 4, val2)"), not(throws_error()))
})




test_that("runMatlabFct returns Matlab results correctly", {
   testthat::skip_on_travis() # since Travis CI has no MATLAB installed tests would fail there


   a       <- c(1,2,1,4,1,5,4,3,2,2,1,6,3,1,8,3,5,5)
   b       <- c(4,6,9,8)
   fcall   <- "[bool, pos] = ismember(b,a)"
   results <- runMatlabFct(fcall)
   expect_true(all(results$bool == c(TRUE, TRUE, FALSE, TRUE)))
   expect_true(all(results$pos == c(4, 12, 0, 15)))



   M         <- matrix(c(2,-1,0,  -1,2,-1,  0,2,3), 3, 3)
   fcall     <- "C = chol(M)"
   results   <- runMatlabFct(fcall)
   C         <- results$C
   C2        <- structure(c(1.4142135623731, 0, 0, -0.707106781186547, 1.22474487139159,
                            0, 0, 1.63299316185545, 0.577350269189625), .Dim = c(3L, 3L))
   expect_true( all(round(C, 8) == round(C2, 8)) ) # from dput
})





test_that("an error is thrown if input is not present in the environment the function was called from (parent frame)", {
   testthat::skip_on_travis()

   nu <- 0.5
   expect_error(runMatlabFct("v = bessely(nu, vec)"),
                regexp = "Matlab input argument (given in fcall) does not exist: vec",
                fixed = TRUE)
})





test_that("result is not null for input with special symbols", {
   testthat::skip_on_travis()

   A <- matrix(runif(16), 4, 4)
   expect_that(res <- runMatlabFct("A_=inv(A)"), not(throws_error()))
   expect_false(is.null(res$A_))



   nu_  <- 0.32
   vec_ <- c(1,2,5,2,6)
   expect_that(res_ <- runMatlabFct("v_ = bessely(nu_, vec_)"), not(throws_error()))
   expect_false(is.null(res_$v_))
})





# # should be commented out because plot window/Matlab has to be terminated manually when no
# # Matlab output was specified in the argument to runMatalbFct():
#
# test_that("function works when no output was specified", {
#    testthat::skip_on_travis()
#
#    x <- seq(1, 2.5*pi, 0.01)
#    y <- (sin(x))^4
#    expect_that(runMatlabFct("plot( x , y )"), not(throws_error()))
# })






# # should be commented out because R package una and the pairwiseVertexSimilarity()
# # function are not public:
#
# test_that("temporary files are deleted automatically", {
#    testthat::skip_on_travis()
#
#    A    <- una::randDir(7, p = 0.23)
#
#    D2   <- reach::runMatlabFct("D2 = pairwiseVertexSimilarity(A, 1)")$D2
#    expect_false(file.exists("tmp_1.mat"))
#
#    method <- 1
#    D2   <- reach::runMatlabFct("D2 = pairwiseVertexSimilarity(A, method)")$D2
#    expect_false(file.exists("tmp_1.mat"))
#
#
#
#    M <- reach::runMatlabFct("M = magic(7)")
#    expect_false(file.exists("tmp_1.mat"))
#
#
#
#    A  <- matrix(sample(1,100,25), 5, 5)
#    B  <- matrix(runif(100), 10, 10)
#    expect_that(out <- runMatlabFct("out=matlab_test_fct_1(11, 22, A, 44, 55, 66, 777, B)"), not(throws_error()))
#    expect_false(file.exists("tmp_1.mat"))
#    expect_that(out <- runMatlabFct("out=matlab_test_fct_1(1, A)"), not(throws_error()))
#    expect_false(file.exists("tmp_1.mat"))
# })
