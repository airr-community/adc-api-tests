# Test Dataset

The ADC API is a query-only API and does not specify how data gets
loaded into the repository. These are instructions for loading the
test dataset into the ADC API reference implementation. There are also
some hints about loading into your own data repository.

# Loading the test dataset into the ADC API reference implementation repository

The data load scripts have these assumptions:

- The ADC API reference implementation is configured and running.
- Data loading is done on the same machine where the API is running.
- Data loading needs access to the configured docker images.
- Data loading needs access to MongoDB directory on the host machine.

Loading the data set should be as simple as these steps:

```
# MongoDB directory on host, same as what is in docker-compose.yml
export MONGO_DBDIR=/disk/mongodb
bash load_dataset.sh
```

The load scripts will delete the old data, based upon the
`repertoire_id` and `data_processing_id`, before inserting the data,
so you should be able to re-run the loading without duplicating any
data. Here is some detail about what each script does.

## load_dataset.sh

Top-level script. It first loads the repertoire data then it loads the
rearrangement data.

## load_repertoire.sh

You can run this script by itself to only load the repertoire data.

- Runs the `import_repertoire.py` script within docker to generate a
  JavaScript import program.

- Runs the generated JavaScript import program in the Mongo database
  which performs the actual data insertion.

- Delete temporary files.

## import_repertoire.py

- Creates a temporary directory.

- Uses the authentication information residing the docker image to
  connect to the database.

- Reads the `florian.airr.yaml` repertoire metadata file and generates
  a JavaScript program to load the data.

- For each repertoire, the JavaScript program deletes that
  `repertoire_id` then inserts the repertoire.

## load_rearrangement.sh

You can run this script by itself to only load the rearrangement
data. Because of the size of the rearrangement data, it is not stored
within the github for the test suite. The data is downloaded from the
VDJServer Community Data Portal. If you have already downloaded the
data then you may comment out the command that runs `download_data.py`
at the beginning of the script.

- Downloads the rearrangement data from VDJServer Community Data
  Portal with the `download_data.py` script.

- For each repertoire, runs the `import_rearrangement.py` script to
  generate a JavaScript import program.

- Runs the generated JavaScript import program in the Mongo database
  which performs the actual data insertion.

- Delete temporary files.

## import_rearrangement.py

- Creates a temporary directory.

- Uses the authentication information residing the docker image to
  connect to the database.

- Reads the rearrangement AIRR TSV file and generates
  a JavaScript program to load the data.

- The JavaScript program first deletes all rearrangements for the
  `repertoire_id` and `data_processing_id` then inserts the
  rearrangements.

## download_data.py

This script has hard-coded URLs and identifiers to the data within the
VDJServer Community Data Portal. In particular, the identifiers point
to IgBlast jobs that have generated AIRR TSV files. VDJServer does not
provide direct links for downloads for anonymous users. It requires a
postit to be generated for the file, which will then provide a
one-time URL to download the data. The script then performs the
download and uncompresses the data files.

# Loading the test dataset into your own data repository

Most likely, you will want to use your own data loading scripts for
your repository versus trying to modify these scripts. Assuming that
your scripts handle the standard AIRR formats for repertoire metadata
(json, yaml) and for rearrangement data (AIRR TSV), then the main task
is to acquire that data then run your scripts on it.

## Repertoire metadata

All of the repertoires reside in `florian.airr.yaml`. The repertoires
have `data_processing_files` defined, which contains the name of the
AIRR TSV file holding the rearrangement data. Note that there are two
different data processing, one for TCR and the other for BCR.

## Rearrangement data

Because of the size of the rearrangement data, it is not stored within
the github for the test suite. The data is downloaded from the
VDJServer Community Data Portal. The `download_data.py` script assumes
it is running within the docker image. However, it does not require
docker, it is just being used so that the necessary python libraries
and `unzip` program are available.

If you run within a docker image, map `/work` directory to a host
directory where you want the data to be stored.

If you run outside of docker, you will likely need to modify the
script to change `/work` to a different directory.
