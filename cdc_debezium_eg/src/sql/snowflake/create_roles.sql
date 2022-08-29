!SET variable_substitution=true;
use role securityadmin;

create user if not exists mysql_rep identified  by '&{PASS}';