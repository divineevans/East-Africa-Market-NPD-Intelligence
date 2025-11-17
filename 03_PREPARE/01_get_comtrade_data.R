###############################################################
# 01_get_comtrade_data.R
# Purpose: Automated UN Comtrade extraction for EA (imports)
#          *** MAX STABILITY V0 SCRIPT: Reduced scope & longer pause ***
###############################################################

library(httr)
library(jsonlite)
library(dplyr)
library(lubridate)
library(purrr)

###############################################################
# 1. Ensure required directories exist (append only)
###############################################################

dirs <- c(
  "03_PREPARE/data_raw",
  "03_PREPARE/data_clean",
  "03_PREPARE/logs"
)

for (d in dirs) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

###############################################################
# 2. Parameters (V0 API - Scope Reduced)
###############################################################

# --- !!! RUN 1 of 2: Use only the first 5 codes to reduce complexity !!! ---
hs_codes <- c("2009","2106","2201","2202","2203") 

reporters <- c("404","800","834","231")      # KE, UG, TZ, ET
years <- 2018:2024
flow_code <- "M"                             
partner_code <- "All"                        
base_url <- "https://comtrade.un.org/api/get"

###############################################################
# 3. Function to pull a single batch (V0 API)
###############################################################

get_comtrade_batch <- function(reporter, hs, year) {
  
  query <- list(
    max = 50000,             
    type = "C",              
    freq = "A",              
    px = "HS",               
    ps = year,               
    r = reporter,            
    p = partner_code,        
    rg = 1,                  
    cc = hs,                 
    fmt = "json",            
    head = "A"               
  )
  
  resp <- GET(base_url, query = query)
  status <- status_code(resp)
  
  if (status != 200) {
    message(paste("⚠ V0 API error for:", reporter, hs, year, "— Status:", status))
    # Print content head to diagnose (should be JSON, not HTML)
    content_text <- content(resp, "text", encoding = "UTF-8")
    message(paste("   Response Content Head:", substr(content_text, 1, 100)))
    
    log_msg <- paste(Sys.time(), 
                     "ERROR", reporter, hs, year, 
                     status,
                     "\n")
    write(log_msg, file = "03_PREPARE/logs/comtrade_errors.log", append = TRUE)
    
    return(NULL)
  }
  
  data <- fromJSON(content(resp, "text", encoding = "UTF-8"))
  
  if (!"dataset" %in% names(data)) return(NULL)
  if (length(data$dataset) == 0) return(NULL)
  
  as_tibble(data$dataset)
}

###############################################################
# 4. Loop through reporters × HS × years
###############################################################

results <- list()

for (r in reporters) {
  for (hs in hs_codes) {
    for (yr in years) {
      
      message(paste("Pulling:", r, hs, yr))
      Sys.sleep(6)   # <<< INCREASED SAFETY PAUSE TO 6 SECONDS
      
      df <- get_comtrade_batch(r, hs, yr)
      
      if (!is.null(df)) {
        results[[length(results) + 1]] <- df
      }
      
    }
  }
}

###############################################################
# 5. Bind rows
###############################################################

if (length(results) == 0) {
  stop("❌ No data returned. Check network, or V0 API availability/limits.")
}

trade_raw <- bind_rows(results)

# Append "_BATCH1" to the file name to distinguish runs
saveRDS(trade_raw, "03_PREPARE/data_raw/comtrade_raw_BATCH1.rds")

###############################################################
# 6. Create cleaned dataset (V0 API column names assumed)
###############################################################

trade_clean <- trade_raw %>%
  select(
    reporter = rtCode,        
    country  = rtTitle,       
    year     = yr,            
    hs_code  = cmdCode,       
    hs_desc  = cmdDesc,       
    trade_value = TradeValue, 
    net_weight  = NetWeight,  
    qty = AltQty,             
    qtyUnit = AltQtyUnit      
  ) %>%
  mutate(
    year = as.numeric(year),
    trade_value = as.numeric(trade_value),
    net_weight = as.numeric(net_weight)
  )

saveRDS(trade_clean, "03_PREPARE/data_clean/comtrade_clean_BATCH1.rds")

message("✅ Comtrade pipeline BATCH 1 complete (using stable V0 API).")