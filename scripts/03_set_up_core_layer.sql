/**********************************************************************************************
 File: 02_set_up_core_layer.sql
 Author: Roberto Chiaiese
 Description:
   This script creates the *Core Layer* tables within the CovidReporting Data Warehouse.
   The Core Layer integrates standardized data from the Staging Layer into a structured
   dimensional model (Star Schema). This schema supports analytical queries and forms
   the foundation for the Gold Layer aggregations and Power BI visualizations.

   The design includes both daily- and weekly-granularity fact tables, ensuring flexibility
   for time-series reporting and trend analysis.

 Tables Created:
   • core.dimCountry                   – Stores country-level metadata and population details
   • core.dimDate                      – Provides detailed daily date dimension
   • core.factCasesAndDeaths           – Records daily confirmed cases and deaths per country
   • core.factTesting                  – Tracks testing and positivity rates (weekly level)
   • core.factDailyHospitalAdmissions  – Tracks daily hospital and ICU occupancy data
**********************************************************************************************/

USE CovidReporting;
GO


-- ============================================================================================
-- Dimension Table: dimCountry
-- --------------------------------------------------------------------------------------------
-- Stores unique country information and population structure.
-- Serves as a reference for all country-related attributes used in analytical joins.
-- ============================================================================================
DROP TABLE IF EXISTS core.dimCountry;
CREATE TABLE core.dimCountry(
	country_id VARCHAR(4),
	country_code VARCHAR(255),
	country VARCHAR(255),
	[population] INT,
	age_0_to_14 FLOAT,
	age_15_to_24 FLOAT,
	age_25_to_49 FLOAT,
	age_50_to_64 FLOAT,
	age_65_to_79 FLOAT,
	age_80_to_MAX FLOAT,
	PRIMARY KEY (country_id)
);


-- ============================================================================================
-- Dimension Table: dimDate
-- --------------------------------------------------------------------------------------------
-- Provides a detailed calendar dimension with daily granularity.
-- Enables temporal analysis at multiple levels: day, week, month, and year.
-- ============================================================================================
DROP TABLE IF EXISTS core.dimDate;
CREATE TABLE core.dimDate(
	date_id INT NOT NULL,
	[date] DATE,
	[year] INT,
	[month] INT,
	[day] INT,
	day_name VARCHAR(255),
	day_of_year INT,
	week_of_month INT,
	week_of_year INT,
	month_name VARCHAR(255),
	year_month INT,
	year_week VARCHAR(10),
	PRIMARY KEY (date_id)
);


-- ============================================================================================
-- Fact Table: factCasesAndDeaths
-- --------------------------------------------------------------------------------------------
-- Stores the daily number of confirmed cases and deaths per country.
-- Linked to both dimCountry and dimDate via foreign keys.
-- ============================================================================================
DROP TABLE IF EXISTS core.factCasesAndDeaths;
CREATE TABLE core.factCasesAndDeaths(
	cases_deaths_id INT,
	country_id VARCHAR(4),
	date_id INT,
	confirmed_cases INT,
	[source] NVARCHAR(MAX),
	PRIMARY KEY (cases_deaths_id),
	FOREIGN KEY (country_id) REFERENCES core.dimCountry(country_id) ON DELETE CASCADE,
	FOREIGN KEY (date_id) REFERENCES core.dimDate(date_id) ON DELETE CASCADE
);


-- ============================================================================================
-- Fact Table: factTesting
-- --------------------------------------------------------------------------------------------
-- Contains testing data (e.g., tests performed, positivity rate, and new cases).
-- Uses weekly granularity via year and week_of_year attributes.
-- date_id can reference the first day of the week in dimDate for consistency.
-- ============================================================================================
DROP TABLE IF EXISTS core.factTesting;
CREATE TABLE core.factTesting(
	test_id NVARCHAR(255),
	country_id VARCHAR(4),
	date_id INT,
	new_cases INT,
	tests_done INT,
	testing_rate FLOAT,
	positivity_rate FLOAT,
	[year] INT,
	week_of_year INT,
	year_week INT,
	[source] NVARCHAR(MAX),
	PRIMARY KEY (test_id),
	FOREIGN KEY (country_id) REFERENCES core.dimCountry(country_id) ON DELETE CASCADE,
	FOREIGN KEY (date_id) REFERENCES core.dimDate(date_id) ON DELETE CASCADE
);


-- ============================================================================================
-- Fact Table: factDailyHospitalAdmissions
-- --------------------------------------------------------------------------------------------
-- Records daily hospital and ICU occupancy counts for each country.
-- Enables correlation analysis between hospitalization and infection trends.
-- ============================================================================================
DROP TABLE IF EXISTS core.factDailyHospitalAdmissions;
CREATE TABLE core.factDailyHospitalAdmissions(
	fact_daily_hosp_id INT,
	country_id VARCHAR(4),
	date_id INT,
	icu_occupancy INT,
	hosp_occupancy INT,
	[source] NVARCHAR(MAX),
	PRIMARY KEY (fact_daily_hosp_id),
	FOREIGN KEY (country_id) REFERENCES core.dimCountry(country_id) ON DELETE CASCADE,
	FOREIGN KEY (date_id) REFERENCES core.dimDate(date_id) ON DELETE CASCADE
);
