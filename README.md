# cloudgov-demo-postgrest

This demo shows you how to get a federally-compliant REST API for your CSV data on [cloud.gov](https://cloud.gov) in about 60 seconds. 

[ATO](https://atos.open-control.org/steps/#top) not included.

# Trying it out

## Deploying the demo
If you haven't already, [set up your cloud.gov account](https://cloud.gov/docs/getting-started/accounts/) and [log in to cloud.gov](https://cloud.gov/docs/getting-started/setup/).

Open a terminal, then clone this repository.

```sh
~$ git clone https://github.com/GSA/cloudgov-demo-postgrest.git
```

(Alternatively, [download a ZIP file](https://codeload.github.com/GSA/cloudgov-demo-postgrest/zip/master) and unzip it to create the `cloudgov-demo-postgrest` folder.)

Change into that directory.

```sh
~$ cd cloudgov-demo-postgrest
```

Copy `vars.yml.template` to `vars.yml`, and run the deploy script

```sh
~$ cp vars.yml.template vars.yml
~$ ./deploy.sh
```

Once that operation completes, run

```sh
~$ cf apps
```

You'll see the URL your application was assigned. The output will look like:

```sh
Getting apps in org sandbox-agencyname / space your.name as your.name@agencyname.gov...
OK

name        requested state   instances   memory   disk   urls
postgrest   started           1/1         512M     1G     postgrest-vivacious-wolverine-lu.app.cloud.gov
```

You can now run (with your own URL):

```sh
~$ curl -s "https://{your-app-url}/Inspection_Results_School_Food_Service?GradeRecent=eq.C" | jq .
```

You should see a nicely formatted JSON response using the awesome [`jq`](https://stedolan.github.io/jq/) utility. To learn more about querying data in PostgREST, [see the docs](https://postgrest.org/en/v3.2/api_reading.html#filtering).

## Cleaning up the demo

Run 
```sh
./cleanup.sh
```

# Next steps

## Try using your own data

The sample data is in the [`data`](data) directory. You can drop your own `.csv` files there before running `./deploy.sh`. Each file you put in the directory will be turned into a REST API endpoint. (For example, the filename `myfile.csv` will be available at the REST API endpoint `https://{your-app-url}/myfile`).

## Try customizing the data import process

You can edit the `init.sh` script in the [`data`](data) directory and go to town. (The default behavior just uses [`csvkit`](https://csvkit.readthedocs.io), which you might find useful.)

#  DBAs demand answers

## WHAT IS THIS SORCERY?!

This was all made possible through the magic of [PostgREST](http://postgrest.org)... We're just providing the cloud.gov glue here. With this tech in hand, you're not just a DBA, you're a backend web developer now. Just about every aspect of the API's behavior is controlled by the content of the database. Have a look at [the PostgREST docs](http://postgrest.org/en/v6.0/) to see what else you can do! You can customize your deployment by placing `.sql` files in the `data/` directory. The files will be run in order immediately after the `.csv` files are loaded.

## What about access control?

You can't create users in the databse. That's because the `shared-psql` plan in use is a community resource, and does not give you `CREATEUSER` or `CREATEROLE` permissions. You'll need to switch to the `medium-psql` plan or higher for that; we didn't do that for this demo because it costs cloud.gov money to operate those instances.

## How can I scale this up?

```sh
cf scale -i INSTANCES -m MEMORY postgrest
```

...where `INSTANCES` is the number of web services you want serving requests, and `MEMORY` is the memory allocated for each instance.

## How much does this cost to run? 

It's free to run this demo in your sandbox space. See [cloud.gov pricing](https://cloud.gov/pricing/) if you want to instead host it in a more durable prototyping or production space. (Note that using both PostgREST and cloud.gov is going to save you a ridiculous amount of money on custom app code and compliance, so make sure you're comparing the cost of cloud.gov hosting to the real costs of going another route.)

# Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for additional information.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
