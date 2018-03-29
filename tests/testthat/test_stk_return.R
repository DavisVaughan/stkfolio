context("stk_return")

# Test data sets
test_prices <- make_test_vector()

# Tests

test_that("First value is 0", {
  ret <- stk_return(test_prices)
  expect_equal(ret[1], 0)
})

test_that("Invalid types are caught", {
  expect_error(stk_return(test_prices, type = "bad"))
})
