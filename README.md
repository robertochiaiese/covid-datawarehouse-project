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

## 📁 Project Structure
├── docker-compose.yml
├── Dockerfile
├── scripts/
│ ├── etl_process.py
│ └── init_db.sql
├── dataset/
│ ├── ecdc-data/
│ │ ├── cases_deaths.csv
│ │ ├── hospital_admissions.csv
│ │ ├── testing.csv
│ │ └── population_by_age.csv
│ └── lookup/
│ ├── dim_date.csv
│ └── country_lookup.csv
└── README.md


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
  
  docker-compose up --build

  Access the database

bash
psql -h localhost -p 5500 -U postgres -d CovidReporting

