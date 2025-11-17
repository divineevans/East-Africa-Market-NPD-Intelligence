############################################################
# 02_clean_comtrade_manual.R
# Purpose: Clean manually downloaded UN Comtrade file
# Input: 03_PREPARE/data_raw/un_comtrade/comtrade_KEUGTZET_2018_2024.csv
# Output: data_clean/comtrade_clean.csv & comtrade_ea_slim.csv
# APAPASA Phase: PREPARE
############################################################

library(readr)
library(dplyr)
library(stringr)

# ---------------------------------------------------------
# 1. Load raw file
# ---------------------------------------------------------
raw_path <- "03_PREPARE/data_raw/un_comtrade/comtrade_KEUGTZET_2018_2024.csv"

comtrade_raw <- read_csv(raw_path, show_col_types = FALSE)

# ---------------------------------------------------------
# 2. Keep only EA import data
# ---------------------------------------------------------
east_africa <- c("Kenya", "Uganda", "Tanzania", "Ethiopia")

comtrade_ea <- comtrade_raw %>%
  filter(
    reporterDesc %in% east_africa,
    flowDesc == "Import"
  )

# ---------------------------------------------------------
# 3. Select essential fields
# ---------------------------------------------------------
comtrade_clean <- comtrade_ea %>%
  select(
    country            = reporterDesc,
    year               = refYear,
    hs_code            = cmdCode,
    hs_description     = cmdDesc,
    trade_value_usd    = primaryValue,
    net_weight_kg      = netWgt,
    quantity           = qty,
    quantity_unit      = qtyUnitAbbr
  ) %>%
  mutate(
    year            = as.integer(year),
    trade_value_usd = as.numeric(trade_value_usd),
    net_weight_kg   = as.numeric(net_weight_kg),
    quantity        = as.numeric(quantity)
  )

# ---------------------------------------------------------
# 4. Save cleaned CSV
# ---------------------------------------------------------
clean_path <- "03_PREPARE/data_clean/comtrade_clean.csv"
write_csv(comtrade_clean, clean_path)

# ---------------------------------------------------------
# 5. Build analytical slim table (summaries)
# ---------------------------------------------------------
comtrade_ea_slim <- comtrade_clean %>%
  group_by(country, year, hs_code, hs_description) %>%
  summarise(
    total_trade_value_usd = sum(trade_value_usd, na.rm = TRUE),
    total_weight_kg       = sum(net_weight_kg, na.rm = TRUE),
    .groups = "drop"
  )

slim_path <- "03_PREPARE/data_clean/comtrade_ea_slim.csv"
write_csv(comtrade_ea_slim, slim_path)

message("✅ Manual Comtrade cleaning complete:
- Clean file: comtrade_clean.csv
- Analytical file: comtrade_ea_slim.csv")
