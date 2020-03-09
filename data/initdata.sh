#!/bin/bash

# This script loads up the data in the database. Customize to taste!

# Default behavior:
# For each CSV file, set up a same-name table with a schema based on the header row, and populate it with data.
# NOTE: This will drop existing tables with the same name! Only use CSV for standing up read-only API endpoints,
# or you will lose data that you've inserted via the REST API the next time you deploy.
csvsql --overwrite --db $DATABASE_URL --db-schema $DB_SCHEMA --insert data/*.csv

