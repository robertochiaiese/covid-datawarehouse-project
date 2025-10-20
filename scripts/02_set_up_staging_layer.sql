
DROP TABLE IF EXISTS staging.cases_deaths;
CREATE TABLE staging.cases_deaths(
	country VARCHAR(255),
	country_code VARCHAR(4),
	continent VARCHAR(255),
	population_count INT NOT NULL,
	daily_count INT,
	reported_date DATE,
	rate_14_day INT,
	source_info VARCHAR(255));


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


DROP TABLE IF EXISTS staging.populations;
CREATE TABLE staging.populations (
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