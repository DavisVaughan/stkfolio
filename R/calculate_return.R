#' Calculate returns at specified intervals
#'
#' Calculate arithmetic or log returns at specified periods.
#'
#' @inheritParams tibbletime::partition_index
#' @param .tbl_time A `tbl_time` object
#' @param ... The columns to calculate returns for.
#' One or more unquoted column names separated by commas.
#' @param type Either `"arithmetic"` or `"log"` returns.
#' @param suffix For each column specified in `...`, this is the suffix that
#' is appended onto the name of the new column that corresponds to the return.
#'
#' @details
#'
#' These functions make no attempt to ensure that you have a full period in
#' your return calculations. This means that if you calculate monthly returns
#' from daily returns but you do not have a complete
#' month of returns for your first month, you may get a value that does not
#' make much sense. It is up to the user to keep this in mind!
#'
#' @name calculate_return
#'
#' @export
calculate_return <- function(.tbl_time, ..., type = "arithmetic",
                             period = "daily", start_date = NULL,
                             suffix = "return") {
  UseMethod("calculate_return")
}

#' @export
calculate_return.default <- function(.tbl_time, ..., type = "arithmetic",
                                     period = "daily", start_date = NULL,
                                     suffix = "return") {
  glue_stop_not_tbl_time(.tbl_time)
}

#' @export
calculate_return.tbl_time <- function(.tbl_time, ..., type = "arithmetic",
                                      period = "daily", start_date = NULL,
                                      suffix = "return") {

  price_vars <- tidyselect::vars_select(names(.tbl_time), !!! rlang::quos(...))
  index_quo  <- tibbletime::get_index_quo(.tbl_time)
  parsed_period <- tibbletime::parse_period(period)

  # Must select something
  assert_price_var_selected(price_vars)

  # Change periods. Including endpoints results so we have something we can
  # calculate correct returns on
  .tbl_time_periodized <- tibbletime::as_period(
    .tbl_time         = .tbl_time,
    period            = period,
    start_date        = start_date,
    side              = "end",
    include_endpoints = TRUE
  )

  # Add on returns
  .tbl_time_returns <- dplyr::mutate_at(
    .tbl  = .tbl_time_periodized,
    .vars = price_vars,
    .funs = dplyr::funs(
      !! suffix := stk_return(., type = type)
    )
  )

  # If period is NOT daily, remove the first row (contains a 0 return)
  # Why?) For yearly returns, you don't want the 0 at the beginning.
  # Really anytime you change periodicity, you don't want it.
  is_1_day <- (parsed_period$period == "day") && (parsed_period$freq == 1)
  if(!is_1_day) {
    .tbl_time_returns<- dplyr::filter(.tbl_time_returns, row_number() != 1L)
  }

  .tbl_time_returns
}

