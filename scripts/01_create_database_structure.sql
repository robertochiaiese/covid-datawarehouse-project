/**********************************************************************************************
 File: 01_create_database_structure.sql
 Author: Roberto Chiaiese
 Description:
   This script creates the core database and schema structure for the CovidReporting 
   Data Warehouse project. It follows the Medallion Architecture model, which organizes 
   data into three layers for efficient transformation and analysis:
     • Bronze Layer – Raw data ingestion
     • Silver Layer – Cleaned and transformed data
     • Gold Layer – Curated, analytics-ready data

 Steps:
   1. Drop existing CovidReporting database if it exists
   2. Create a new CovidReporting database
   3. Define the Medallion Architecture schemas (bronze, silver, gold)

 Usage:
   Execute this script in Microsoft SQL Server Management Studio (SSMS)
   before loading any data or creating tables.

**********************************************************************************************/

USE master;
GO

-- Drop the database 'CovidReporting' if already exists
IF EXISTS (SELECT 1 FROM SYS.databases WHERE name = 'CovidReporting')
	BEGIN
		ALTER DATABASE CovidReporting SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE CovidReporting;
	END;
GO

-- Create CovidReporting database
CREATE DATABASE CovidReporting;
GO

-- Use the database
USE CovidReporting;
GO

-- Create the bronze layer
CREATE SCHEMA bronze;
GO

-- Create the silver layer
CREATE SCHEMA silver;
GO

-- Create the gold layer
CREATE SCHEMA gold;
