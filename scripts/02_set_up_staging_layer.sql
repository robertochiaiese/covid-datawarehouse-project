/**********************************************************************************************
 File: 02_set_up_staging_layer.sql
 Author: Roberto Chiaiese
 Description:
   This script creates the *Staging Layer* tables for the CovidReporting Data Warehouse.
   The Staging Layer serves as the initial landing zone for raw data ingested 
   from the ECDC COVID-19 datasets and other related public data sources. 

   Data in this layer is stored in its original format (minimal transformation)
   to ensure traceability, auditing, and reproducibility before being cleaned and
   integrated into the Core Layer.

 Tables Created:
   • staging.cases_deaths         – Raw data on daily COVID-19 cases and deaths
   • staging.testing              – Raw testing data including test counts and positivity rate
   • staging.hospital_admissions  – Raw hospital and ICU admission data
   • staging.populations          – Population data by country and year (2008–2019)

 Usage:
   Execute this script after the staging schema has been created.
   Run in Microsoft SQL Server Management Studio (SSMS) or via an automated pipeline.

**********************************************************************************************/


-- ============================================
-- Table: staging.cases_deaths
-- Description:
--   Contains raw COVID-19 daily case and death counts 
--   by country and reporting date as provided by ECDC.
--   Also includes population and source metadata.
-- ============================================
DROP TABLE IF EXISTS staging.cases_deaths;
CREATE TABLE staging.cases_deaths(
	country VARCHAR(255),
	country_code VARCHAR(4),
	continent VARCHAR(255),
	population_count INT NOT NULL,
	daily_count INT,
	reported_date DATE,
	rate_14_day INT,
	source_info VARCHAR(255)
);


-- ============================================
-- Table: staging.testing
-- Description:
--   Stores raw COVID-19 testing data such as new cases,
--   number of tests performed, positivity rate, and testing rate.
--   Each record corresponds to a country and epidemiological week.
-- ============================================
DROP TABLE IF EXISTS staging.testing;
CREATE TABLE staging.testing(
	country VARCHAR(255),
	country_code VARCHAR(255),
	year_week VARCHAR(255),
	new_cases INT,
	tests_done INT,
	population_count INT,
	testing_rate FLOAT,
	positivity_rate FLOAT,
	testing_data_source VARCHAR(255)
);


-- ============================================
-- Table: staging.hospital_admissions
-- Description:
--   Holds raw data on hospital and ICU admissions 
--   reported daily or weekly by country.
--   The 'indicator' column specifies whether data 
--   refers to hospital or ICU occupancy.
-- ============================================
DROP TABLE IF EXISTS staging.hospital_admissions;
CREATE TABLE staging.hospital_admissions(
	country VARCHAR(255),
	indicator VARCHAR(255),
	reported_date DATE,
	reported_year_week VARCHAR(255),
	number INT,
	source_info VARCHAR(255),
	url_link VARCHAR(255)
);


-- ============================================
-- Table: staging.population_by_age
-- Description:
--   Contains population statistics per country (geo)
--   and indicator (indic_de), covering the years 2008–2019.
--   This data is useful for demographic and normalization analysis.
-- ============================================
DROP TABLE IF EXISTS staging.population_by_age;
CREATE TABLE staging.population_by_age(
    indic_de VARCHAR(25),
    geo VARCHAR(25),
    [2008] FLOAT,
    [2009] FLOAT,
    [2010] FLOAT, 
    [2011] FLOAT,
    [2012] FLOAT, 
    [2013] FLOAT, 
    [2014] FLOAT,
    [2015] FLOAT,
    [2016] FLOAT,
    [2017] FLOAT,
    [2018] FLOAT,
    [2019] FLOAT
);
