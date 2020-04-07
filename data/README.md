## Sample data

The data in the `Inspection_Results_School_Food_Service.csv` file comes from the [City of Louisville open data portal](https://data.louisvilleky.gov/dataset/environmental-health-inspection-results).

### Supplying your own CSV data

You can replace this file with one of your own, or add new `.csv` files in this directory. Each file you put in this directory will be turned into a REST API endpoint when you run `./deploy.sh`. (For example, the filename `myfile.csv` will be available at the REST API endpoint `https://URL/myfile`).

Note - before running `./deploy.sh` on new data files in this directory, make sure your [csv file is valid](https://csvkit.readthedocs.io/en/1.0.2/scripts/csvclean.html) and properly formatted.

```sh
~$ csvclean -n data/myfile.csv
```

### Customizing the API further with SQL

Any `.sql` files found here will be run immediately after the `.csv` files are loaded into the DB. You can use this capability to further customize the table schema, set up roles for access control, etc. [Have a look at the PostgREST docs](http://postgrest.org/en/v6.0/) to learn more.