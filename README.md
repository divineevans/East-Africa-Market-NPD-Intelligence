# AromaCraft – East Africa Market & NPD Intelligence
**Data Analytics Mastery Program — Project 2 (Consumer Products)**  
Author: **Evans Gichunji**  
Last Updated: 2025-11-16  

---

## 📌 Project Overview
This repository contains the complete APAPASA‑aligned workflow for generating an industry‑grade **Market & NPD Intelligence Report** for **AromaCraft Ingredients Ltd.**, focused on **East Africa** (Kenya, Uganda, Tanzania, Ethiopia).

The project integrates **multiple public datasets** (Open Food Facts, UN Comtrade, Kaggle datasets) and a fully engineered **PostgreSQL analytics backend** to produce insights similar to those used by flavour houses, beverage manufacturers, and FMCG innovation teams.

---

## 🧭 APAPASA Framework Structure

```
01_ASK/       → Business understanding, analytical questions
02_PLAN/      → SOW, project plan, data inventory
03_PREPARE/   → Raw data, cleaned datasets, ETL scripts + Data Changelog
04_ANALYSE/   → R Markdown notebooks, statistical analysis, modelling
05_SHARE/     → Slide decks, PDF reports, Tableau dashboards
06_ACT/       → Strategic recommendations, action notes
```

---

## 🗄️ Data Architecture

### **Raw Data Layer (`03_PREPARE/data_raw/`)**
- UN Comtrade EA imports (2018–2024)  
- Open Food Facts (global cleaned + EA slim analytical)  
- Amazon Fine Food Reviews  
- Grocery Inventory & Sales Dataset  
- Synthetic Beverage Sales Dataset  

### **Clean Data Layer (`03_PREPARE/data_clean/`)**
- `comtrade_clean.csv`  
- `comtrade_ea_slim.csv`  
- `grocery_clean.csv`  
- `amazon_reviews_clean.csv`  
- `beverage_sales_clean.csv`  
- `products_ea_slim.csv`  

### **Analytical Layer (`analytics/` or database schema)**
- `products_ea_slim` (EA product/ingredient/flavour metadata)  
- `ea_sales_category`  
- `ea_flavour_sentiment`  
- `ea_trade_flows`  
- `ea_market_model`  

All analytical tables are stored in **PostgreSQL**.

---

## 🔧 Environment Setup

### **Run the global setup script**
```
source("00_SETUP_GlobalEnvironment.R")
```

This script:
- Loads required R packages  
- Connects to PostgreSQL  
- Creates APAPASA folder structure  
- Loads helper functions  
- Saves session metadata  

### **Environment Variables (`.env`)**
```
PG_HOST=localhost
PG_PORT=5432
PG_DATABASE=aromacraft_project
PG_USER=postgres
PG_PASSWORD=YourPasswordHere
```

(*Note: `.env` is ignored by Git for security.*)

---

## 📜 Data Changelog (Mandatory)

Every raw → clean → analytical transformation must be logged.

### **Format**
```
DATE | TYPE | DESCRIPTION | OUTPUT FILE | SCRIPT
```

### **Entries**
```
2025-11-10 | INGESTION | Imported UN Comtrade 2018–2024 | comtrade_raw.csv | comtrade_ingest.R
2025-11-11 | CLEANING  | Cleaned Comtrade & harmonized HS codes | comtrade_clean.csv | comtrade_clean.R
2025-11-11 | TRANSFORM | Filtered EA countries                 | comtrade_ea_slim.csv | comtrade_ea_slim.R
2025-11-12 | INGESTION | Loaded Amazon Reviews                 | amazon_reviews_raw.csv | amazon_ingest.R
2025-11-12 | CLEANING  | Tokenized reviews + sentiment fields  | amazon_reviews_clean.csv | amazon_clean.R
2025-11-13 | CLEANING  | Harmonized Grocery Dataset            | grocery_clean.csv | grocery_clean.R
2025-11-13 | TRANSFORM | Cleaned beverage synthetic sales      | beverage_sales_clean.csv | beverage_sales_clean.R
2025-11-14 | TRANSFORM | Final OFF EA analytical table         | products_ea_slim.csv | off_ea_slim.R
2025-02-14 | IMPUTATION | Standardised 'unit_price' to numeric and removed currency symbols | grocery_inventory_clean.csv | prep_price_pack_grocery.R
2025-02-14 | IMPUTATION | Imputed missing 'unit_price' using category median values | grocery_inventory_clean.csv | prep_price_pack_grocery.R
2025-02-14 | TRANSFORM  | Created 'revenue' = unit_price * sales_volume | grocery_inventory_clean.csv | prep_price_pack_grocery.R
2025-02-14 | TRANSFORM  | Created 'price_tier' using quantile-based bucketing | grocery_inventory_clean.csv | prep_price_pack_grocery.R

2025-02-14 | CLEANING   | Normalised product names (trim/lowercase) | synthetic_beverage_sales_clean.csv | prep_price_pack_bevsales.R
2025-02-14 | IMPUTATION | Imputed missing 'unit_price' using category-level medians | synthetic_beverage_sales_clean.csv | prep_price_pack_bevsales.R
2025-02-14 | TRANSFORM  | Added 'total_revenue' and 'unit_discount_price' metrics | synthetic_beverage_sales_clean.csv | prep_price_pack_bevsales.R
2025-02-14 | IMPUTATION | Replaced negative or zero 'quantity' with category median | synthetic_beverage_sales_clean.csv | prep_price_pack_bevsales.R

2025-02-14 | PARSING    | Extracted numeric pack sizes from OFF 'quantity' field (e.g., '300 ml' → 300) | products_ea_slim (PostgreSQL) | prep_off_packsize_parse.R
2025-02-14 | IMPUTATION | Imputed missing pack sizes using brand-level or category-level mode | products_ea_slim (PostgreSQL) | prep_off_packsize_impute.R
2025-02-14 | TRANSFORM  | Standardised all pack sizes to millilitres/grams for cross-dataset comparability | products_ea_slim (PostgreSQL) | prep_off_packsize_impute.R
```

---

## 📈 Analysis Overview (Phase 04)

The analysis phase will include:
- Category CAGR modelling  
- Price/pack architecture  
- Flavour & ingredient trends  
- NPD innovation patterns  
- Consumer sentiment analysis  
- Trade flow triangulation  
- Market sizing model  
- Priority flavour recommendations  

Outputs:
- R Markdown notebooks  
- Interactive Tableau dashboards  
- Executive PDF reports  

---

## 📄 License (MIT)

```
MIT License

Copyright (c) 2025 Evans

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...
```

---

## 🤝 Contact
**Evans Gichunji**  
Data Analyst 
Kenya, East Africa
