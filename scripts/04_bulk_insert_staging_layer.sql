/**********************************************************************************************
 File: 04_bulk_insert_staging_layer.sql
 Author: Roberto Chiaiese
 Description:
   This script performs bulk data loading from raw CSV files into the *Staging Layer* tables.
   The staging layer acts as a temporary holding area for raw datasets before data cleansing,
   transformation, and integration into the Core Layer.
   
   The script uses the BULK INSERT command to efficiently import large CSV files while 
   maintaining control over delimiters, NULL handling, and transactional locking.
**********************************************************************************************/

USE CovidReporting;
GO


-- ============================================================================================
-- Load Data into staging.cases_deaths
-- --------------------------------------------------------------------------------------------
-- Description:
--   Imports daily COVID-19 case and death counts per country.
-- Notes:
--   • Data source: ecdc-datasets\cases_deaths.csv
--   • Fields are delimited by semicolons (';')
--   • The first row contains column headers
-- ============================================================================================
TRUNCATE TABLE staging.cases_deaths;

BULK INSERT staging.cases_deaths
FROM 'C:\Users\rober\Desktop\Project-1-DW\dataset\ecdc-datasets\cases_deaths.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	KEEPNULLS,
	TABLOCK
);


-- ============================================================================================
-- Load Data into staging.testing
-- --------------------------------------------------------------------------------------------
-- Description:
--   Imports testing data including test counts, rates, and positivity metrics.
-- Notes:
--   • Data source: ecdc-datasets\testing.csv
--   • Fields are delimited by commas (',')
--   • The first row contains headers
-- ============================================================================================
TRUNCATE TABLE staging.testing;

BULK INSERT staging.testing
FROM 'C:\Users\rober\Desktop\Project-1-DW\dataset\ecdc-datasets\testing.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);


-- ============================================================================================
-- Load Data into staging.population_by_age
-- --------------------------------------------------------------------------------------------
-- Description:
--   Imports population distribution by age groups for each country.
-- Notes:
--   • Data source: ecdc-datasets\population_by_age.csv
--   • Fields are delimited by commas (',')
--   • The first two rows contain metadata; actual data starts from row 3
-- ============================================================================================
TRUNCATE TABLE staging.population_by_age;

BULK INSERT staging.population_by_age
FROM 'C:\Users\rober\Desktop\Project-1-DW\dataset\ecdc-datasets\population_by_age.csv'
WITH (
	FIRSTROW = 3,
	FIELDTERMINATOR = ',',
	TABLOCK
);


-- ============================================================================================
-- Load Data into staging.hospital_admissions
-- --------------------------------------------------------------------------------------------
-- Description:
--   Imports daily hospital and ICU admissions per country.
-- Notes:
--   • Data source: ecdc-datasets\hospital_admissions.csv
--   • Fields are delimited by commas (',')
--   • Uses '\n' as the row terminator to handle UNIX-style line endings
-- ============================================================================================
TRUNCATE TABLE staging.hospital_admissions;

BULK INSERT staging.hospital_admissions
FROM 'C:\Users\rober\Desktop\Project-1-DW\dataset\ecdc-datasets\hospital_admissions.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	KEEPNULLS
);
