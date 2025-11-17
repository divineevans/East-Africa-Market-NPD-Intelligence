############################################################
# 02_clean_grocery_inventory.R
# Purpose: Clean Grocery Inventory & Sales dataset
# Input : 03_PREPARE/data_raw/Grocery_Inventory_and_Sales_Dataset.csv
# Output: 03_PREPARE/data_clean/grocery_inventory_clean.csv
# Notes : Keep only relevant fields + lowercase + clean price
############################################################

library(readr)
library(dplyr)
library(stringr)
library(janitor)

# -------------------------------------------
# 1. Load raw data
# -------------------------------------------
raw_path <- "03_PREPARE/data_raw/Grocery_Inventory_and_Sales_Dataset.csv"

grocery_raw <- read_csv(raw_path, show_col_types = FALSE)

# -------------------------------------------
# 2. Standardize column names → lowercase
# -------------------------------------------
grocery_std <- grocery_raw %>% 
  janitor::clean_names()   # makes all columns lowercase with underscores

# -------------------------------------------
# 3. Clean unit_price field
#    Format example: "$4.50" → 4.50
# -------------------------------------------
grocery_std <- grocery_std %>%
  mutate(
    unit_price = str_replace_all(unit_price, "[$,]", ""),   # remove $ and commas
    unit_price = as.numeric(unit_price)
  )

# -------------------------------------------
# 4. Select only relevant columns
# -------------------------------------------
grocery_clean <- grocery_std %>%
  select(
    product_id,
    product_name,
    category = catagory,        # fixing the original misspelling
    stock_quantity,
    unit_price,
    sales_volume,
    inventory_turnover_rate
  )

# -------------------------------------------
# 5. Save cleaned file
# -------------------------------------------
clean_path <- "03_PREPARE/data_clean/grocery_inventory_clean.csv"
write_csv(grocery_clean, clean_path)

message("✅ Grocery Inventory cleaning complete:
- Saved: grocery_inventory_clean.csv")
