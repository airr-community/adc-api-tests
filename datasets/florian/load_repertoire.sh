#
# Runs all the commands to load the dataset.
#
# The ADC API service must be running.
# Assumes the various docker images are available.
#
# The scripts will delete the data in the database (assuming
# the same repertoire_id) before inserting the data, so this
# script can be re-run if necessary without duplicating data.
#
# TODO: data processing ids
#

if [ -z $MONGO_DBDIR ]; then
    echo "Need to define MONGO_DBDIR where Mongo database files reside"
    exit
fi

# import the repertoires
echo "Loading repertoires"
docker run -v $PWD:/work -v $MONGO_DBDIR:/work_data -it airrc/adc-api-js-mongodb python3 /work/import_repertoire.py
docker exec -it adc-api-mongo mongo --authenticationDatabase admin v1airr /data/db/tmp/repertoire.js
docker run -v $PWD:/work -v $MONGO_DBDIR:/work_data -it airrc/adc-api-js-mongodb rm -rf /work_data/tmp
