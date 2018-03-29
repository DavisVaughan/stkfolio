# ------------------------------------------------------------------------------
# Assertions

assert_valid_return_type <- function(type) {
  is_valid <- any(type == valid_return_types())
  if(!is_valid) {
    valid_types <- glue::collapse(yellow(valid_return_types()), last = ", or ")
    glue_stop("{green(type)} is an unsupported return calculation type. Use {valid_types}.")
  }
}

assert_price_var_selected <- function(price_vars) {
  something_selected <- length(price_vars) > 0
  if(!something_selected) {
    glue_stop("You must select at least 1 column to calculate returns for.")
  }
}

# ------------------------------------------------------------------------------
# Assertion helpers

valid_return_types <- function() {
  c("arithmetic", "log")
}
