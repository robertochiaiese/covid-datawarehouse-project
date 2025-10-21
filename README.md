# CovidReporting Data Warehouse Project

### Author
**Roberto Chiaiese**

---

## 📖 Project Overview
This project builds a complete **data warehouse pipeline** for COVID-19 reporting and analysis.  
The system integrates raw epidemiological and demographic data from public datasets (such as the ECDC COVID-19 repositories), cleans and organizes it through SQL and Python (Pandas), and visualizes the results in **Microsoft Power BI**.

The data warehouse is designed with two primary layers:

- **Staging Layer:** Raw data ingestion and temporary storage.
- **Core Layer:** Cleaned, structured, and integrated data optimized for analytical queries and dashboards.

---

## 🧱 Database Structure

### 1. Database Initialization
**File:** `01_create_database_structure.sql`  
Creates the main `CovidReporting` database and defines the logical schemas:
- `staging` – stores raw data as initially ingested.
- `core` – stores cleaned and transformed data ready for analysis.

### 2. Staging Layer Setup
**File:** `02_set_up_staging_layer.sql`  
Defines the staging tables used to temporarily hold imported data:
- `staging.cases_deaths` – daily cases and deaths by country.  
- `staging.testing` – testing activity and positivity rates.  
- `staging.hospital_admissions` – hospital and ICU admissions data.  
- `staging.population_by_age` – population distribution by age group and year.

### 3. Core Layer Setup
**File:** `03_set_up_core_layer.sql`  
Creates the dimensional model (Star Schema) supporting analytical queries:
- `core.dimCountry` – country-level reference data.  
- `core.dimDate` – detailed date dimension for time-series analysis.  
- `core.factCasesAndDeaths` – daily cases and deaths per country.  
- `core.factTesting` – testing and positivity metrics at weekly granularity.  
- `core.factDailyHospitalAdmissions` – hospital and ICU occupancy data.

### 4. Bulk Data Loading
**File:** `04_bulk_insert_staging_layer.sql`  
Loads raw CSV files into the `staging` tables using `BULK INSERT` for efficient ingestion.  
Each dataset is then ready for transformation and integration into the `core` schema.

---

## 🐍 Python Integration
Python scripts (based on **Pandas**) were used to:
- Clean and preprocess CSV datasets before import.  
- Perform basic data validation and consistency checks.  
- Automate table creation and bulk insert operations when required.

---

## 📊 Data Visualization
The cleaned and structured data from the **core layer** feeds into **Microsoft Power BI** dashboards, enabling:
- Country-level comparisons of cases, deaths, and testing rates.  
- Trends in hospital and ICU admissions.  
- Normalized metrics based on population structure and age groups.

---

## ⚙️ Tools and Technologies
- **Microsoft SQL Server** – Database management and schema definition.  
- **Python (Pandas)** – Data cleaning, preprocessing, and automation.  
- **Microsoft Power BI** – Interactive analytics and visualization.  

---


