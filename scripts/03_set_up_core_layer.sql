/**********************************************************************************************
 File: 03_set_up_core_layer.sql
 Author: Roberto Chiaiese
 Description:
   This script creates the *Core Layer* tables within the CovidReporting Data Warehouse.
   The Core Layer acts as an intermediate stage that integrates and organizes 
   standardized data from the Silver Layer into structured dimensional and fact tables.
   This layer supports analytical queries and serves as the foundation for the 
   final Gold Layer aggregations and reports.

   The schema follows a classic *star schema* design pattern with dimension and fact tables.

 Tables Created:
   • core.dimCountry                   – Stores country-level metadata and population details
   • core.dimPopulationByAge           – Stores demographic distribution by age group per country
   • core.dimDate                      – Contains temporal dimensions for time-based analysis
   • core.factCasesAndDeaths           – Records confirmed cases and deaths per date and country
   • core.factTesting                  – Contains testing-related metrics such as tests and positivity rate
   • core.factDailyHospitalAdmissions  – Captures daily hospital and ICU occupancy
   • core.factWeeklyHospitalAdmissions – Aggregated weekly hospital and ICU occupancy

 Usage:
   Execute this script after the core schema has been created and the Silver Layer is populated.
   Run in Microsoft SQL Server Management Studio (SSMS) or via an automated pipeline.

**********************************************************************************************/


-- ============================================
-- Dimension Table: Country
-- Description:
--   Contains reference data for countries including
--   country codes, names, and total population.
-- ============================================
DROP TABLE IF EXISTS core.dimCountry;
CREATE TABLE core.dimCountry(
	country_key INT,
	country_name VARCHAR(255),
	country_code_2 VARCHAR(4),
	country_code_3 VARCHAR(4),
	[source] VARCHAR(255),
	population_total INT,
	PRIMARY KEY (country_key)
);


-- ============================================
-- Dimension Table: Population by Age
-- Description:
--   Stores demographic distribution by age group
--   for each country. Linked to dimCountry.
-- ============================================
DROP TABLE IF EXISTS core.dimPopulationByAge;
CREATE TABLE core.dimPopulationByAge(
	population_age_key INT NOT NULL,
	country_key INT,
	age_0_to_14 FLOAT,
	age_15_to_24 FLOAT,
	age_25_to_49 FLOAT,
	age_50_to_64 FLOAT,
	age_65_to_79 FLOAT,
	age_80_to_MAX FLOAT,
	PRIMARY KEY (population_age_key),
	FOREIGN KEY (country_key) REFERENCES core.dimCountry(country_key)
);


-- ============================================
-- Dimension Table: Date
-- Description:
--   Provides temporal reference data for analytics,
--   including full date, year, month, and week details.
-- ============================================
DROP TABLE IF EXISTS core.dimDate;
CREATE TABLE core.dimDate(
	date_key INT NOT NULL,
	full_date DATE,
	[year] INT,
	[month] INT,
	[day] INT,
	year_week VARCHAR(10),
	PRIMARY KEY (date_key)
);


-- ============================================
-- Fact Table: Cases and Deaths
-- Description:
--   Contains COVID-19 confirmed cases and deaths
--   by country and date. Links to dimCountry and dimDate.
-- ============================================
DROP TABLE IF EXISTS core.factCasesAndDeaths;
CREATE TABLE core.factCasesAndDeaths(
	fact_cases_id INT,
	country_key INT,
	date_key INT,
	confirmed_cases INT,
	population_total INT,
	[source] VARCHAR(255),
	PRIMARY KEY (fact_cases_id),
	FOREIGN KEY (country_key) REFERENCES core.dimCountry(country_key),
	FOREIGN KEY (date_key) REFERENCES core.dimDate(date_key)
);


-- ============================================
-- Fact Table: Testing
-- Description:
--   Stores COVID-19 testing data including number of tests,
--   new cases, testing rate, and positivity rate.
-- ============================================
DROP TABLE IF EXISTS core.factTesting;
CREATE TABLE core.factTesting(
	fact_testing_id INT,
	country_key INT,
	date_key INT,
	new_cases INT,
	tests_done INT,
	testing_rate FLOAT,
	positivity_rate FLOAT,
	[source] VARCHAR(255)
);


-- ============================================
-- Fact Table: Daily Hospital Admissions
-- Description:
--   Tracks daily hospital and ICU occupancy per country.
--   Supports short-term trend and capacity analysis.
-- ============================================
DROP TABLE IF EXISTS core.factDailyHospitalAdmissions;
CREATE TABLE core.factDailyHospitalAdmissions(
	fact_daily_hosp_id INT,
	country_key INT,
	date_key INT,
	icu_occupancy INT,
	hosp_occupancy INT,
	population_total INT,
	[source] VARCHAR(255),
	PRIMARY KEY (fact_daily_hosp_id),
	FOREIGN KEY (country_key) REFERENCES core.dimCountry(country_key),
	FOREIGN KEY (date_key) REFERENCES core.dimDate(date_key)
);


-- ============================================
-- Fact Table: Weekly Hospital Admissions
-- Description:
--   Aggregated weekly view of hospital and ICU occupancy.
--   Used for monitoring medium-term healthcare trends.
-- ============================================
DROP TABLE IF EXISTS core.factWeeklyHospitalAdmissions;
CREATE TABLE core.factWeeklyHospitalAdmissions(
	fact_weekly_hosp_id INT,
	country_key INT,
	date_key INT,
	icu_occupancy INT,
	hosp_occupancy INT,
	population_total INT,
	[source] VARCHAR(255),
	PRIMARY KEY (fact_weekly_hosp_id),
	FOREIGN KEY (country_key) REFERENCES core.dimCountry(country_key),
	FOREIGN KEY (date_key) REFERENCES core.dimDate(date_key)
);
