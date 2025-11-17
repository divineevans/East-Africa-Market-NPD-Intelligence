############################################################
# 00_SETUP_GlobalEnvironment.R
# Purpose: One-stop environment setup for APAPASA projects
# Author: Evans Gichunji
############################################################

### 1. Required packages ----
required_pkgs <- c(
  "tidyverse", "DBI", "RPostgres", "dotenv",
  "readxl", "writexl", "janitor", "lubridate", 
  "stringr", "tidytext", "broom", "ggplot2", 
  "scales", "knitr"
)

installed_pkgs <- rownames(installed.packages())
for (pkg in required_pkgs) {
  if (!pkg %in% installed_pkgs) {
    install.packages(pkg, dependencies = TRUE)
  }
}
lapply(required_pkgs, library, character.only = TRUE)

message("📦 All required R packages loaded successfully.")

### 2. Load environment variables ----
if (file.exists(".env")) {
  dotenv::load_dot_env(".env")
  message("🔐 .env variables loaded.")
} else {
  message("⚠️ .env file not found. Create one for database credentials.")
}

### 3. Create APAPASA project folder structure ----
dirs <- c(
  "01_ASK",
  "02_PLAN",
  "03_PREPARE/data_raw",
  "03_PREPARE/data_clean",
  "04_ANALYSE",
  "05_SHARE",
  "06_ACT"
)

for (d in dirs) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}
message("📁 APAPASA folders verified/created.")

### 4. Connect to local PostgreSQL ----
pg_host     <- Sys.getenv("PG_HOST")
pg_port     <- Sys.getenv("PG_PORT")
pg_db       <- Sys.getenv("PG_DATABASE")
pg_user     <- Sys.getenv("PG_USER")
pg_password <- Sys.getenv("PG_PASSWORD")

if (pg_host != "" && pg_user != "") {
  tryCatch({
    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      dbname   = pg_db,
      host     = pg_host,
      port     = pg_port,
      user     = pg_user,
      password = pg_password
    )
    assign("pg_con", con, envir = .GlobalEnv)
    message("🗄️ Connected to PostgreSQL successfully.")
  }, error = function(e) {
    message("❌ PostgreSQL connection failed: ", e$message)
  })
} else {
  message("⚠️ PostgreSQL credentials missing in .env.")
}

### 5. Load helper functions ----
if (file.exists("utils/helpers.R")) {
  source("utils/helpers.R")
  message("🧰 Helper functions loaded.")
}

### 6. Save session info ----
writeLines(capture.output(sessionInfo()), "session_info.txt")
message("📘 Session info saved to session_info.txt")

message("🌍 Global environment setup complete.")
############################################################
