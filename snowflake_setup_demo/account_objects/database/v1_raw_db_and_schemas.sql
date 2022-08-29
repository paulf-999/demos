!SET variable_substitution=true;
/*
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE &{PROGRAM}_DEVELOPER_WH;
DROP DATABASE IF EXISTS &{PROGRAM}_RAW_DB;
*/

USE ROLE &{PROGRAM}_DBA;
USE WAREHOUSE &{PROGRAM}_DEVELOPER_WH;

--create raw_db structure
CREATE DATABASE IF NOT EXISTS &{PROGRAM}_RAW_DB COMMENT = 'Ingestion / landing area, containing raw, non-transformed source system data';
CREATE SCHEMA IF NOT EXISTS &{PROGRAM}_RAW_DB.PRODUCTION WITH MANAGED ACCESS;
CREATE SCHEMA IF NOT EXISTS &{PROGRAM}_RAW_DB.SALES WITH MANAGED ACCESS;
CREATE SCHEMA IF NOT EXISTS &{PROGRAM}_RAW_DB.UTILITIES WITH MANAGED ACCESS COMMENT = 'Contains all database objects other than tables or views';
DROP SCHEMA IF EXISTS &{PROGRAM}_RAW_DB.PUBLIC;