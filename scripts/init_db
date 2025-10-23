/**********************************************************************************************
 File: 01_create_database_structure.sql
 Author: Roberto Chiaiese
 Description:
   This script initializes the main database and schema structure for the CovidReporting 
   Data Warehouse project. It defines the fundamental layers required for the ETL workflow, 
   following a simplified Medallion-style architecture with dedicated zones for raw and 
   transformed data.

   The database includes:
     • Staging Layer – Raw data ingestion area used for initial loading from external sources
     • Core Layer – Cleaned and standardized data prepared for analytical modeling

 Steps:
   1. Drop the existing CovidReporting database if it exists
   2. Create a new CovidReporting database
   3. Define the Staging (staging) and Core (core) schemas

 Usage:
   Execute this script in Microsoft SQL Server Management Studio (SSMS)
   before creating any tables or loading data.

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

-- Create the staging layer
CREATE SCHEMA staging;
GO

-- Create the core layer
CREATE SCHEMA core;
GO
