#!/bin/bash

csvsql --overwrite --db $DATABASE_URL --db-schema $DB_SCHEMA --insert data/*.csv
