## Sample data

The data in the `Inspection_Results_School_Food_Service.csv` file comes from the [City of Louisville open data portal](https://data.louisvilleky.gov/dataset/environmental-health-inspection-results).

You can replace this file with one of your own, or add new `.csv` files in this directory. Each file you put in this directory will be turned into a REST API endpoint when you run `./deploy.sh`. (For example, the filename `myfile.csv` will be available at the REST API endpoint `https://URL/myfile`).

Note - before running `./deploy.sh` on new data files in this directory, make sure your csv file is valid and properly formatted.

``sh
~$ csvclean -n data/myfile.csv
```