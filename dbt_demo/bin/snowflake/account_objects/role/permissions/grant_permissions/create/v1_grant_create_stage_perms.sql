!SET variable_substitution=true;
USE ROLE ACCOUNTADMIN;
GRANT CREATE STAGE ON SCHEMA &{PROGRAM}_RAW_DB.UTILITIES TO ROLE &{PROGRAM}_SF_STAGE_ADMIN;