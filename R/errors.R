# ------------------------------------------------------------------------------
# Error messages

glue_stop <- function(..., .sep = "") {
  msg <- glue::glue(..., .sep, .envir = parent.frame())
  stop(msg, call. = FALSE)
}

glue_stop_not_tbl_time <- function(x) {
  classes <- glue::collapse(green(class(x)), sep = ",")
  correct_class <- yellow("tbl_time")
  glue_stop("Object is of class {classes}, but should be of class {correct_class}")
}
