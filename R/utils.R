# ------------------------------------------------------------------------------
# Reexports

#' @importFrom tibbletime as_tbl_time
#' @export
#'
tibbletime::as_tbl_time

#' @importFrom dplyr %>%
#' @export
#'
dplyr::`%>%`

#' @importFrom rlang :=
#'
rlang::`:=`

# ------------------------------------------------------------------------------
# Pure imports

# Only importing this because it doesnt work inside a mutate
# as `dplyr::row_number()`
#' @importFrom dplyr row_number

# Colors for error messages
# green = user entry, yellow = correct entry
#' @importFrom crayon green
#' @importFrom crayon yellow

# ------------------------------------------------------------------------------
# Utils

make_test_vector <- function() {
  c(20.1, 20.5, 23.2, 24.5, 22)
}

make_test_data <- function() {
  tibble::tibble(
    date = as.Date("2016-12-31") + seq_len(5),
    val  = make_test_vector()
  )
}

make_test_tbl_time_data <- function() {
  as_tbl_time(make_test_data(), date)
}
