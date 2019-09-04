#
# This script is VDJServer specific.
# This script is specific to this dataset.
#
# This script does not directly import the data
# into the database, instead it creates a JavaScript
# file by Mongo to do the import.
#
# This script utilizes the adc-api-js-mongodb docker image
# which has database connection information.
#

from dotenv import load_dotenv
import json
import os
import airr
import yaml
import requests
import argparse

# Setup
def getConfig():
    if load_dotenv(dotenv_path='/adc-api-js-mongodb/.env'):
        cfg = {}
        cfg['host'] = os.getenv('MONGODB_HOST')
        cfg['db'] = os.getenv('MONGODB_DB')
        cfg['service_user'] = os.getenv('MONGODB_SERVICE_USER')
        cfg['service_secret'] = os.getenv('MONGODB_SERVICE_SECRET')
        cfg['username'] = os.getenv('MONGODB_USER')
        cfg['password'] = os.getenv('MONGODB_SECRET')
        return cfg
    else:
        print('ERROR: loading config')
        return None

# main entry
if (__name__=="__main__"):
    parser = argparse.ArgumentParser(description='Load AIRR rearrangements into VDJServer data repository.')
    parser.add_argument('repertoire_id', type=str, help='Repertoire identifier for the rearrangements')
    parser.add_argument('rearrangement_file', type=str, help='Rearrangement AIRR TSV file name')
    args = parser.parse_args()

    if args:
        # connection header
        config = getConfig()
        header = 'var conn = new Mongo();\n'
        header += 'var db = conn.getDB("admin");\n'
        header += 'db.auth("' + config['service_user'] + '", "' + config['service_secret'] + '");\n'
        header += 'db = db.getSiblingDB("' + config['db'] + '");\n'

        print("Reading file: " + args.rearrangement_file)
        reader = airr.read_rearrangement(args.rearrangement_file)

        os.system("mkdir /work_data/tmp")
        fnum = 0
        fname = '/work_data/tmp/rearrangement' + str(fnum) + '.js'
        print('Creating file: ' + fname)
        fout = open(fname, 'w')
        fout.write(header)

        # delete any existing records
        fout.write('db.rearrangement.deleteMany({"repertoire_id":"' + args.repertoire_id + '"});\n');

        seqCount = 0
        for row in reader:
            if row.get('repertoire_id') is None:
                row['repertoire_id'] = args.repertoire_id
            if len(row['repertoire_id']) == 0:
                row['repertoire_id'] = args.repertoire_id

            fout.write('var ret = db.rearrangement.insertOne(' + json.dumps(row) + ');\n')
            fout.write('db.rearrangement.updateOne({"_id":ret["insertedId"]},{$set:{"rearrangement_id":ret["insertedId"].str}});\n')
            seqCount += 1
            # don't let the files get too big
            if seqCount % 50000 == 0:
                fnum += 1
                fout.close();
                fname = '/work_data/tmp/rearrangement' + str(fnum) + '.js'
                print('Creating file: ' + fname)
                fout = open(fname, 'w')
                fout.write(header)
