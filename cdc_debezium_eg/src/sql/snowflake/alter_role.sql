!SET variable_substitution=true;
use role securityadmin;

alter user mysql_rep set rsa_public_key='&{PASS}';
