#!/bin/bash

# Get the location of the directory where the script was run.
PROG_NAME=`basename "$0"`
SCRIPT_DIR=`dirname "$0"`

NB_ARGS=1
if [ $# -lt $NB_ARGS ];
then
    echo "$PROG_NAME: wrong number of arguments ($# instead of at least $NB_ARGS)"
    echo "usage: $PROG_NAME adc_url"
    exit 1
fi

# Get the URL and shift the parameters.
adc_url="$1"
shift

curl --data '{"size":5}' ${adc_url}/repertoire > base.repertoire.json
curl --data '{"include_fields":"miairr","size":5}' ${adc_url}/repertoire > miairr.repertoire.json
curl --data '{"fields":["repertoire_id"],"include_fields":"miairr","size":5}' ${adc_url}/repertoire > miairr2.repertoire.json
curl --data '{"include_fields":"airr-core","size":5}' ${adc_url}/repertoire > core.repertoire.json
curl --data '{"fields":["repertoire_id"],"include_fields":"airr-core","size":5}' ${adc_url}/repertoire > core2.repertoire.json
curl --data '{"include_fields":"airr-schema","size":5}' ${adc_url}/repertoire > all.repertoire.json
curl --data '{"fields":["repertoire_id"],"include_fields":"airr-schema","size":5}' ${adc_url}/repertoire > all2.repertoire.json

airr-tools validate repertoire -a base.repertoire.json
airr-tools validate repertoire -a miairr.repertoire.json
airr-tools validate repertoire -a miairr2.repertoire.json
airr-tools validate repertoire -a core.repertoire.json
airr-tools validate repertoire -a core2.repertoire.json
airr-tools validate repertoire -a all.repertoire.json
airr-tools validate repertoire -a all2.repertoire.json
