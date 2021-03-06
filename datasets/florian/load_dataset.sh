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

bash load_repertoire.sh
bash load_rearrangement.sh
