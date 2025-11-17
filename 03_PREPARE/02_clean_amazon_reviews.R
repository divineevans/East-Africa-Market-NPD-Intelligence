############################################################
# 02_clean_amazon_reviews.R
# Purpose: Clean Amazon Fine Food Reviews dataset
# Input: 03_PREPARE/data_raw/amazon_fine_food_reviews.csv
# Output: 03_PREPARE/data_clean/amazon_reviews_clean.csv
# APAPASA Phase: PREPARE
############################################################

library(readr)
library(dplyr)
library(stringr)
library(janitor)

# ---------------------------------------------------------
# 1. Load raw dataset
# ---------------------------------------------------------
raw_path <- "03_PREPARE/data_raw/amazon_fine_food_reviews.csv"

amazon_raw <- read_csv(raw_path, show_col_types = FALSE)

# ---------------------------------------------------------
# 2. Standardize column names (lowercase, snake_case)
# ---------------------------------------------------------
amazon_raw <- amazon_raw %>% 
  janitor::clean_names()

# ---------------------------------------------------------
# 3. Select ONLY relevant columns
# Keep: product_id, score, summary, text
# ---------------------------------------------------------
amazon_clean <- amazon_raw %>%
  select(
    product_id,
    score,
    summary,
    text
  ) %>%
  mutate(
    score = as.numeric(score),
    summary = str_squish(summary),
    text = str_squish(text)
  )

# ---------------------------------------------------------
# 4. Save cleaned dataset
# ---------------------------------------------------------
clean_path <- "03_PREPARE/data_clean/amazon_reviews_clean.csv"
write_csv(amazon_clean, clean_path)

message("
✅ Amazon Fine Food Reviews cleaning complete:
- Clean file: amazon_reviews_clean.csv
- Columns retained: product_id, score, summary, text
")
