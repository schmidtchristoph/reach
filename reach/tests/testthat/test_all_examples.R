library(reach)
library(testthat)

context("Testing examples in documentation")

devtools::document()
test_examples()
