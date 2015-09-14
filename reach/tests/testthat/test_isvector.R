library(reach)
library(testthat)

context("isvector")



test_that("a scalar value is not a vector and does correctly return FALSE", {
   s <- 122
   expect_identical(reach:::isvector(s), FALSE)


   s <- "here"
   expect_identical(reach:::isvector(s), FALSE)


   s <- FALSE
   expect_identical(reach:::isvector(s), FALSE)


   s <- TRUE
   expect_identical(reach:::isvector(s), FALSE)
})





test_that("a vector of different type correctly yields TRUE", {
   v <- c(1, 0.3, 0.0007, 45)
   expect_identical(reach:::isvector(v), TRUE)
   expect_identical(reach:::isvector( t(v) ), TRUE)


   v <- c("here", "and", "beer")
   expect_identical(reach:::isvector(v), TRUE)
   expect_identical(reach:::isvector( t(v) ), TRUE)


   v <- c(TRUE, FALSE, FALSE)
   expect_identical(reach:::isvector(v), TRUE)
   expect_identical(reach:::isvector( t(v) ), TRUE)


   v <- matrix(c(1, 2, 3, 4, 5, 6), 6, 1)
   expect_identical(reach:::isvector(v), TRUE)
   expect_identical(reach:::isvector( t(v) ), TRUE)


   v <- matrix(c(77, 2, 33, 444, 5, 0), 1, 6)
   expect_identical(reach:::isvector(v), TRUE)
   expect_identical(reach:::isvector( t(v) ), TRUE)
})





test_that("a matrix correctly yields FALSE", {
   m <- matrix(c(1, 2, 3, 4), 2, 2)
   expect_identical(reach:::isvector(m), FALSE)
   expect_identical(reach:::isvector( t(m) ), FALSE)


   m <- array(1:3, c(2,4))
   expect_identical(reach:::isvector(m), FALSE)
   expect_identical(reach:::isvector( t(m) ), FALSE)
})
