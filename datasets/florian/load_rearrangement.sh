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

# download and unzip the rearrangement data
docker run -v $PWD:/work -t airrc/adc-api-js-mongodb python3 /work/download_data.py

# import the rearrangements
BCR_DP_ID=6414d653-edd2-4d26-be1d-98a82f5e9c98-007
TCR_DP_ID=d097e851-c2ac-4bc9-89ca-93845f3cfbc0-007
export BCR_PATH=/work/${BCR_DP_ID}
export TCR_PATH=/work/${TCR_DP_ID}

function load_rearrangements() {
    echo ""
    echo Loading rearrangement0.js
    docker exec -it adc-api-mongo mongo --authenticationDatabase admin v1airr /data/db/tmp/rearrangement0.js
    for f in $MONGO_DBDIR/tmp/rearrangement*.js; do
	fileBasename="${f##*/}"
	if [ "$fileBasename" == "rearrangement0.js" ]; then
	    echo ""
	else
	    echo Loading $fileBasename
	    docker exec -it adc-api-mongo mongo --authenticationDatabase admin v1airr /data/db/tmp/${fileBasename}
	    echo ""
	fi
    done
    docker run -v $PWD:/work -v $MONGO_DBDIR:/work_data -it airrc/adc-api-js-mongodb rm -rf /work_data/tmp
}

SCRIPT="docker run -v $PWD:/work -v $MONGO_DBDIR:/work_data -it airrc/adc-api-js-mongodb python3 /work/import_rearrangement.py"
echo ""
echo "Loading rearrangements"

$SCRIPT 1841923116114776551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW01A_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 1602908186092376551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW01A_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 2366080924918616551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01A_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 2541616238306136551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01A_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 1993707260355416551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01A_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 2197374609531736551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01A_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 2848663450297176551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW01B_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 2685411743376216551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW01B_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 3438706057421656551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01B_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 3628844259615576551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01B_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 2989624276951896551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01B_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 3252733973504856551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW01B_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 4181735399629656551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW02A_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 3924638657291096551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW02A_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 4744762662462296551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02A_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 4931851437876056551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02A_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 4357957907784536551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02A_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 4476756703191896551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02A_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 5531257073705816551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW02B_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 5215877625160536551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW02B_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 6205695788196696551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02B_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 6393557657723736551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02B_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 7158276584776536551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02B_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 5953881855632216551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW02B_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 6819446614795096551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW03A_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 7972301736387416551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW03A_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 7461458326201176551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03A_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 7640859110155096551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03A_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 6964444710708056551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03A_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 7313153105470296551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03A_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 8112833066312536551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW03B_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 7793588147200856551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW03B_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 8602072790999896551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03B_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 8733756488295256551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03B_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 8263242821018456551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03B_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 8425807333172056551-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW03B_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 7885350151947415065-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW04A_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 8945756074025816551-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW04A_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 7309695685264535065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04A_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 8485700680582295065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04A_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 9084118473933975065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04A_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 8961797805343895065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04A_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 7745763714827415065-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW04B_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 6738379135550615065-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW04B_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 5624006920930455065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04B_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 7066128089908375065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04B_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 7591789137265815065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04B_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 7446748091679895065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW04B_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 6576544767837335065-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW05A_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 6880327804683415065-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW05A_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 6088937130722455065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05A_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 5939858815878295065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05A_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 6389112395039895065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05A_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 6240077029868695065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05A_T_memory_CD8.igblast.airr.tsv
load_rearrangements

$SCRIPT 5462430251254935065-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW05B_B_naive.igblast.airr.tsv
load_rearrangements
$SCRIPT 5765010697258135065-242ac11c-0001-012 ${BCR_DP_ID} ${BCR_PATH}/TW05B_B_memory.igblast.airr.tsv
load_rearrangements
$SCRIPT 5039977268020375065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05B_T_naive_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 4858300151399575065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05B_T_naive_CD8.igblast.airr.tsv
load_rearrangements
$SCRIPT 5338391595746455065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05B_T_memory_CD4.igblast.airr.tsv
load_rearrangements
$SCRIPT 5168912186246295065-242ac11c-0001-012 ${TCR_DP_ID} ${TCR_PATH}/TW05B_T_memory_CD8.igblast.airr.tsv
load_rearrangements
