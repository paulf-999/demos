use role sysadmin;
create warehouse if not exists wh_ingest warehouse_size = xsmall;
create database if not exists mysql_ingest;
create schema if not exists mysql_ingest.landing;

use role securityadmin;
create role if not exists r_mysql_rep;
grant all on database mysql_ingest to role r_mysql_rep;
grant all on schema mysql_ingest.landing to role r_mysql_rep;
grant all on warehouse wh_ingest to role r_mysql_rep;
