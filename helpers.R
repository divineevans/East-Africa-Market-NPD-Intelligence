# utils/helpers.R
# Purpose: Utility functions for data cleaning, logging, and QA

log_action <- function(message) {
  cat(sprintf("[%s] %s\n", Sys.time(), message))
}

clean_column_names <- function(df) {
  df %>% janitor::clean_names()
}
