############################################################
# clean_synthetic_beverage_sales.R
# Purpose: Clean Synthetic Beverage Sales dataset
# Input: 03_PREPARE/data_raw/synthetic_beverage_sales_data.csv
# Output: 03_PREPARE/data_clean/synthetic_beverage_sales_clean.csv
# APAPASA Phase: PREPARE
############################################################

library(readr)
library(dplyr)
library(stringr)
library(lubridate)

# ---------------------------------------------------------
# 1. Load raw file
# ---------------------------------------------------------
raw_path <- "03_PREPARE/data_raw/synthetic_beverage_sales_data.csv"

synthetic_raw <- read_csv(raw_path, show_col_types = FALSE)

# ---------------------------------------------------------
# 2. Standardize column names to lowercase
# ---------------------------------------------------------
synthetic_raw <- synthetic_raw %>%
  rename_all(~ tolower(.))

# ---------------------------------------------------------
# 3. Keep only relevant analytical columns
# ---------------------------------------------------------
synthetic_clean <- synthetic_raw %>%
  select(
    order_id,
    customer_id,
    customer_type,
    product,
    category,
    unit_price,
    quantity,
    discount,
    total_price,
    region,
    order_date
  )

# ---------------------------------------------------------
# 4. Clean numeric columns
# ---------------------------------------------------------
synthetic_clean <- synthetic_clean %>%
  mutate(
    unit_price  = as.numeric(unit_price),
    quantity    = as.integer(quantity),
    discount    = as.numeric(discount),
    total_price = as.numeric(total_price)
  )

# ---------------------------------------------------------
# 5. Clean order date
# ---------------------------------------------------------
synthetic_clean <- synthetic_clean %>%
  mutate(
    order_date = lubridate::ymd(order_date)
  )

# ---------------------------------------------------------
# 6. Save cleaned file
# ---------------------------------------------------------
clean_path <- "03_PREPARE/data_clean/synthetic_beverage_sales_clean.csv"
write_csv(synthetic_clean, clean_path)

message("✅ Synthetic beverage sales cleaning COMPLETE:
- Saved: synthetic_beverage_sales_clean.csv")
