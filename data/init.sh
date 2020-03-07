#!/bin/bash

# Set up the schema and anonymous role in the database, then run any provided .sql files
data/initdb.py data/*.sql

# For each CSV file, set up a same-name table with a schema based on the header row, and populate it with data.
#
# Note: This will drop existing tables with the same name! Only use CSV for standing up read-only API endpoints,
# or data that you've inserted via the REST API will be lost the next time you deploy.
csvsql --overwrite --db $DATABASE_URL --db-schema $DB_SCHEMA --insert data/*.csv

