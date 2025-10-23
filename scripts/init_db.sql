/*
============================================================
File: init_db.sql
Author: Roberto Chiaiese
Project: COVID-19 Data Warehouse

Description:
  This script initializes the PostgreSQL database environment
  for the COVID-19 Data Warehouse project. It creates the 
  main database and defines the schema structure required 
  for data ingestion and transformation.

  - Creates the database 'covidreporting'
  - Connects to it (via psql command)
  - Defines two schemas:
      • staging → for raw ingested data
      • core → for transformed, cleaned, and modeled data
============================================================
*/

-- Create the database
CREATE DATABASE covidreporting;

-- Connect to the database (in psql)
\c covidreporting

-- Create schemas
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS core;
