stk_return <- function(.p, type = "arithmetic") {

  assert_valid_return_type(type)

  if (type == "arithmetic") {

    # P1 / P0 - 1
    ret <- .p / dplyr::lag(.p) - 1

  } else if (type == "log") {

    # log(P1 / P0)
    ret <- log(.p / dplyr::lag(.p))

  }

  # Ensure first value is 0, not NA. Eases calculation
  ret[1] <- 0

  ret
}


