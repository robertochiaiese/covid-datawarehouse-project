# COVID-19 Data Warehouse Project

A comprehensive data warehouse solution for COVID-19 data analysis, featuring ETL processes, dimensional modeling, and analytics using Python, Docker, and Power BI.

## 📊 Project Overview

This project constructs a robust data warehouse for COVID-19 data analysis through automated ETL processes, dimensional data modeling, and interactive analytics dashboards. The system integrates multiple data sources including cases, deaths, hospital admissions, testing data, and population demographics.

## 🏗️ Architecture

### Technology Stack
- **ETL Processing**: Python (Pandas, SQLAlchemy, Psycopg2)
- **Data Storage**: PostgreSQL
- **Containerization**: Docker & Docker Compose
- **Data Visualization**: Power BI
- **Data Sources**: ECDC COVID-19 datasets

### Data Pipeline Architecture
Raw Data Sources → ETL Process → Staging Layer → Core Layer → Analytics & Reporting

<img width="597" height="370" alt="workflow" src="https://github.com/user-attachments/assets/6dbe2ae5-0881-408f-8bb0-9df961d6b875" />


## 📁 Project Structure
```tree
covid-datawarehouse-project/
├── README.md
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
├── scripts/
│   ├── init_db.sql
│   └── etl_process.py
└── datasets/
    ├── raw/
    │   ├── lookup/
    │   │   ├── dim_date.csv
    │   │   └── country_lookup.csv
    │   ├── cases_and_deaths.csv
    │   ├── hospital_admissions.csv
    │   ├── testing.csv
    │   └── population_by_age.csv
    └── processed/
        ├── dim_country.csv
        ├── dim_date.csv
        ├── fact_cases_and_deaths.csv
        ├── fact_daily_hospital_admissions.csv
        └── fact_testing.csv
         

```


## 🗃️ Data Model

### Core Layer Tables

#### Fact Tables
- **fact_cases_and_deaths**: Daily confirmed cases and deaths
- **fact_daily_hospital_admissions**: Hospital and ICU occupancy rates
- **fact_testing**: COVID-19 testing statistics and positivity rates

#### Dimension Tables
- **dim_country**: Country demographics and population age distribution
- **dim_date**: Time dimension for temporal analysis

## 🚀 Quick Start

### Prerequisites
- Docker
- Docker Compose

### Installation & Execution

1. **Clone the repository**
  ```console
  docker-compose up --build
  ```

  
2. Run the complete pipeline
```console
docker-compose up --build
  ```

3.  **Access the database**
  ```console
  psql -h localhost -p 5500 -U postgres -d CovidReporting
  ```



## 🔧 ETL Process Details

### Data Extraction
The ETL process downloads datasets from GitHub repositories and supports multiple data sources:

- **Cases and deaths data** - Daily COVID-19 case and mortality statistics
- **Hospital admissions** - Healthcare facility occupancy and admission rates
- **Testing statistics** - PCR and antigen testing volumes and results
- **Population demographics** - Country-level population and age distribution data
- **Date and country lookup tables** - Reference data for dimensional modeling

### Data Transformation

#### Data Cleaning
- Handling missing values and data quality issues
- Data type conversions and standardization
- Validation of data integrity and consistency

#### Data Integration
- Merging multiple datasets using country codes as foreign keys
- Temporal alignment using date dimensions
- Consolidation of disparate data sources into unified schema

#### Data Enrichment
- Adding calculated fields and derived metrics
- Statistical aggregations and rolling averages
- Geographic and demographic enhancements

#### Dimensional Modeling
- Transformation into star schema format
- Creation of fact and dimension tables
- Optimization for analytical query performance

### Key Transformations

#### Cases and Deaths
- Filters European countries for regional analysis
- Merges with country and date dimensions for contextual analysis
- Creates comprehensive fact table for confirmed cases and mortality

#### Hospital Admissions
- Pivots daily hospital and ICU occupancy data for time-series analysis
- Handles data quality issues and missing values through imputation
- Standardizes healthcare metrics across different reporting formats

#### Testing Data
- Aggregates weekly testing statistics for trend analysis
- Calculates testing rates per capita and population coverage
- Computes positivity rates as key pandemic indicators

#### Population Data
- Creates comprehensive country dimension with detailed demographics
- Calculates mean population values across multiple years for stability
- Structures age distribution data for cohort analysis



## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## 📞 Support

For support, please open an issue in the GitHub repository or contact the maintainers.

---




