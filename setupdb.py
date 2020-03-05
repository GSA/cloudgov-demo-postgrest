#!/usr/bin/python

# Connect to the $DATABASE_URL and attempt to provision anonymous role based on DB_ANON_ROLE/DB_ANON_PASSWORD

import os
import psycopg2
import sys

try:
    conn=psycopg2.connect(os.environ['DATABASE_URL'])
except:
    print "Unable to connect to database"
    sys.exit(-1)

cur = conn.cursor()
try:
    cur.execute('CREATE USER ' + os.environ['DB_ANON_ROLE'] + ' WITH NOCREATEUSER NOCREATEDB ENCRYPTED PASSWORD ' + os.environ['DB_ANON_PASSWORD'])
    # TODO: Import from .csv file here!
except:
    print "Got exception setting up user; likely already exists"

