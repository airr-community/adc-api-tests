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

curl --data '{"size":5,"format":"tsv"}' ${adc_url}/rearrangement > base.rearrangement.tsv
curl --data '{"include_fields":"miairr","size":5,"format":"tsv"}' ${adc_url}/rearrangement > miairr.rearrangement.tsv
curl --data '{"fields":["repertoire_id"],"include_fields":"miairr","size":5,"format":"tsv"}' ${adc_url}/rearrangement > miairr2.rearrangement.tsv
curl --data '{"include_fields":"airr-core","size":5,"format":"tsv"}' ${adc_url}/rearrangement > core.rearrangement.tsv
curl --data '{"fields":["repertoire_id"],"include_fields":"airr-core","size":5,"format":"tsv"}' ${adc_url}/rearrangement > core2.rearrangement.tsv
curl --data '{"include_fields":"airr-schema","size":5,"format":"tsv"}' ${adc_url}/rearrangement > all.rearrangement.tsv
curl --data '{"fields":["repertoire_id"],"include_fields":"airr-schema","size":5,"format":"tsv"}' ${adc_url}/rearrangement > all2.rearrangement.tsv

airr-tools validate rearrangement -a base.rearrangement.tsv
airr-tools validate rearrangement -a miairr.rearrangement.tsv
airr-tools validate rearrangement -a miairr2.rearrangement.tsv
airr-tools validate rearrangement -a core.rearrangement.tsv
airr-tools validate rearrangement -a core2.rearrangement.tsv
airr-tools validate rearrangement -a all.rearrangement.tsv
airr-tools validate rearrangement -a all2.rearrangement.tsv
