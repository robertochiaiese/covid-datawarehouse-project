# -----------------------------------------------
#  ETL Pipeline for COVID Data Warehouse Project
# -----------------------------------------------
# Author: Roberto Chiaiese
# Description:
#   This Python script automates the extraction, transformation,
#   and loading (ETL) of multiple COVID-related datasets
#   into a PostgreSQL data warehouse.
#
#   The script downloads CSV files from this GitHub repository,
#   transforms them into dimension and fact tables,
#   and loads them into 'staging' and 'core' schemas.
# -----------------------------------------------


# ---------- IMPORT LIBRARIES ----------
import pandas as pd
import requests
from io import StringIO
import psycopg2
import numpy as np
from sqlalchemy import create_engine
import os


# ---------- GLOBAL CONFIGURATION ----------
# Base URL of the GitHub repository containing datasets
base_url = 'https://raw.githubusercontent.com/robertochiaiese/datawarehouse/main/dataset/'

# List of datasets to process (relative paths from base_url)
datasets = [
    'ecdc-data/cases_deaths.csv',
    'ecdc-data/hospital_admissions.csv',
    'ecdc-data/testing.csv',
    'ecdc-data/population_by_age.csv',
    'lookup/dim_date.csv'
]

# PostgreSQL connection credentials
username = os.getenv('DB_USERNAME', 'postgres')
password = os.getenv('DB_PASSWORD', 'mysecretpassword')
ipaddress = os.getenv('DB_HOST', 'db')
port = os.getenv('DB_PORT', '5432')
dbname = os.getenv('DB_NAME', 'CovidReporting')

# SQLAlchemy connection string for PostgreSQL
postgres_str = f'postgresql+psycopg2://{username}:{password}@{ipaddress}:{port}/{dbname}'


# ---------- LOOKUP TABLES ----------
# Preload lookup tables directly from GitHub
# These are used for joining country and date information
country_lookup = pd.read_csv(
    StringIO(requests.get(
        'https://raw.githubusercontent.com/robertochiaiese/covid-datawarehouse-project/refs/heads/main/dataset/lookup/country_lookup.csv'
    ).text),
    encoding='utf-8'
)

dimDate = pd.read_csv(
    StringIO(requests.get(
        'https://raw.githubusercontent.com/robertochiaiese/covid-datawarehouse-project/refs/heads/main/dataset/lookup/dim_date.csv'
    ).text),
    encoding='utf-8'
)


# ---------- TRANSFORMATION FUNCTIONS ----------

def transform_dim_date(df):
    """Transform the date dimension table."""
    df = df.rename(columns={'date_key': 'date_id'})
    return df, 'date_id'


def transform_cases_and_deaths(df):
    """Transform the cases and deaths dataset into a fact table."""
    # Merge with lookup tables to add country and date attributes
    fact_cases_and_deaths = pd.merge(df, country_lookup, on='country')
    fact_cases_and_deaths = pd.merge(fact_cases_and_deaths, dimDate, on='date')

    # Keep only European countries and valid records
    fact_cases_and_deaths = fact_cases_and_deaths[
        (fact_cases_and_deaths['country_code_2_digit'].notnull()) &
        (fact_cases_and_deaths['continent_x'] == 'Europe')
    ]

    # Select and rename relevant columns
    fact_cases_and_deaths = fact_cases_and_deaths[
        ['country_code_2_digit', 'date_key', 'daily_count', 'source']
    ].rename(columns={
        'country_code_2_digit': 'country_id',
        'date_key': 'date_id',
        'daily_count': 'confirmed_cases'
    })

    # Add a synthetic primary key
    fact_cases_and_deaths = fact_cases_and_deaths.reset_index().rename(columns={'index': 'cases_deaths_id'})
    
    return fact_cases_and_deaths, 'cases_deaths_id'


def transform_testing(df):
    """Transform testing dataset into a fact table."""
    # Merge with country lookup
    fact_testing = pd.merge(df, country_lookup, on='country', how='left')

    # Select and rename relevant columns
    fact_testing = fact_testing[
        ['country_code_2_digit', 'year_week', 'new_cases', 'tests_done',
         'population_x', 'testing_rate', 'positivity_rate', 'testing_data_source']
    ].rename(columns={
        'country_code_2_digit': 'country_id',
        'year_week': 'reported_year_week',
        'population_x': 'population'
    })

    # Create a numeric representation of the week for joining with dimDate
    fact_testing['reported_date'] = (
        fact_testing['reported_year_week'].str[0:4] + fact_testing['reported_year_week'].str[6:8]
    ).astype("Int64")

    # Merge with date dimension
    fact_testing = pd.merge(fact_testing, dimDate, left_on='reported_date', right_on='year_week', how='left')

    # Aggregate by country and week
    fact_testing = fact_testing.groupby(['country_id', 'reported_year_week']).min('date_key').reset_index().drop(columns='reported_year_week')

    # Reindex and rename for consistency
    fact_testing = fact_testing.reset_index().rename(columns={
        'index': 'test_id', 'date_key': 'date_id', 'year_week': 'reported_date_week'
    })

    # Generate a unique test_id
    fact_testing['test_id'] = fact_testing['country_id'] + fact_testing['date_id'].astype(str)

    # Select relevant fields
    fact_testing = fact_testing[
        ['test_id', 'date_id', 'country_id', 'reported_date_week',
         'new_cases', 'tests_done', 'testing_rate', 'positivity_rate']
    ]
    
    return fact_testing, 'test_id'


def transform_hospital_admissions(df):
    """Transform hospital admissions dataset into a fact table."""
    # Replace missing values and convert types
    hospital_admissions = df.replace(':', np.nan)
    hospital_admissions['value'] = hospital_admissions['value'].fillna(0).astype('int64')

    # Merge with lookup tables
    hospital_admissions = pd.merge(hospital_admissions, country_lookup, on='country', how='left')
    hospital_admissions = pd.merge(hospital_admissions, dimDate, on='date', how='left')

    # Select daily occupancy indicators
    daily_hospital_admissions = hospital_admissions[
        hospital_admissions['indicator'].isin(['Daily hospital occupancy', 'Daily ICU occupancy'])
    ]
    
    # Pivot to have ICU and hospital occupancy as columns
    df_pivot_daily = (
        daily_hospital_admissions.pivot_table(
            index=['country_code_2_digit', 'date_key', 'source'],
            columns='indicator',
            values='value'
        )
    ).reset_index()

    # Rename and format columns
    fact_daily_hospital_admissions = df_pivot_daily.rename(columns={
        'country_code_2_digit': 'country_id',
        'date_key': 'date_id',
        'Daily ICU occupancy': 'icu_occupancy',
        'Daily hospital occupancy': 'hosp_occupancy'
    })

    # Sort and typecast
    fact_daily_hospital_admissions = fact_daily_hospital_admissions.sort_values(by=['country_id', 'date_id'], ascending=[True, False])
    fact_daily_hospital_admissions[['icu_occupancy', 'hosp_occupancy']] = fact_daily_hospital_admissions[['icu_occupancy', 'hosp_occupancy']].astype('Int64')

    # Add synthetic primary key
    fact_daily_hospital_admissions = fact_daily_hospital_admissions.reset_index().rename(columns={'index': 'fact_daily_hosp_id'})

    return fact_daily_hospital_admissions, 'fact_daily_hosp_id'


def transform_population_by_age(df):
    """Transform population by age dataset into a country dimension table."""
    df_merged = pd.merge(df, country_lookup, left_on='geo', right_on='country_code_2_digit')

    # Select relevant columns
    df_merged = df_merged[
        ['country', 'country_code_2_digit', 'country_code_3_digit', 'population', 'indic_de',
         '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019']
    ]

    # Compute mean population by age group
    cols = [str(y) for y in range(2008, 2020)]
    df_merged['mean_value'] = df_merged[cols].mean(axis=1).round(1)

    # Pivot on indicator codes to obtain age distributions
    df_pivoted = df_merged.pivot_table(
        aggfunc='first',
        index=['country', 'country_code_2_digit', 'country_code_3_digit', 'population'],
        columns='indic_de',
        values='mean_value'
    ).reset_index()

    # Rename columns
    df_pivoted = df_pivoted.rename(columns={
        'country_code_2_digit': 'country_id',
        'country_code_3_digit': 'country_code',
        'PC_Y0_14': 'age_0_to_14',
        'PC_Y15_24': 'age_15_to_24',
        'PC_Y25_49': 'age_25_to_49',
        'PC_Y50_64': 'age_50_to_64',
        'PC_Y65_79': 'age_65_to_79',
        'PC_Y80_MAX': 'age_80_to_max'
    })

    dim_country = df_pivoted[
        ['country_id', 'country_code', 'country', 'population',
         'age_0_to_14', 'age_15_to_24', 'age_25_to_49',
         'age_50_to_64', 'age_65_to_79', 'age_80_to_max']
    ]
    
    return dim_country, 'country_id'


# ---------- DATABASE CONNECTION ----------
def postgres_connection():
    """Establish PostgreSQL connections using psycopg2 and SQLAlchemy."""
    try:
        conn = psycopg2.connect(
            host=ipaddress,
            database=dbname,
            user=username,
            port=port,
            password=password
        )
        conn.autocommit = True
        cur = conn.cursor()
        cnx = create_engine(postgres_str)

    except Exception as e:
        print("Something went wrong:", str(e))
        exit(0)
    
    return conn, cur, cnx


# ---------- DATA INGESTION ----------
def ingest_data(dataset):
    """Download a dataset from GitHub and load it into a Pandas DataFrame."""
    full_url = base_url + dataset
    print(f"Downloading from: {full_url}")
    
    response = requests.get(full_url)
    response.raise_for_status()  # raises error if file not found
    
    df = pd.read_csv(StringIO(response.text), encoding='utf-8')
    return df


# ---------- MAIN ETL EXECUTION ----------
list_function = [
    transform_cases_and_deaths,
    transform_hospital_admissions,
    transform_testing,
    transform_population_by_age,
    transform_dim_date
]

list_core_names = [
    'fact_cases_and_deaths',
    'fact_daily_hospital_admissions',
    'fact_testing',
    'dim_country',
    'dim_date'
]

# Create database connections
conn, cur, cnx = postgres_connection()

# Process each dataset through the ETL pipeline
for d, f, n in zip(datasets, list_function, list_core_names):
    # --- Extraction ---
    s = ingest_data(d)
    tbname = d.split('/')[1].split('.')[0]

    # --- Load into Staging Layer ---
    print(f'Loading: {tbname} into staging layer...')
    s.to_sql(
        name=tbname,
        schema='staging',
        con=cnx,
        if_exists='replace',
        index=False
    )
    print(f'Loading completed!')

    # --- Transformation ---
    print(f'Transforming {tbname} → {n}...')
    c, primary_key = f(s)
    print(f'Transformation completed!')

    # --- Load into Core Layer ---
    print(f'Loading: {n} into core layer...')
    c.to_sql(
        name=n,
        schema='core',
        con=cnx,
        if_exists='replace',
        index=False
    )
    print(f'Loading completed!')

    # --- Add Primary Key Constraint ---
    cur.execute(f'ALTER TABLE core.{n} ADD PRIMARY KEY ({primary_key});')

    print('\n' + '_'*40 + '\n')

# Close database connection
conn.close()
print("ETL Process Completed Successfully!")
