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

# connection header
config = getConfig()
header = 'var conn = new Mongo();\n'
header += 'var db = conn.getDB("admin");\n'
header += 'db.auth("' + config['service_user'] + '", "' + config['service_secret'] + '");\n'
header += 'db = db.getSiblingDB("' + config['db'] + '");\n'

os.system("mkdir /work_data/tmp")
fname = '/work_data/tmp/repertoire.js'
print('Creating file: ' + fname)
fout = open(fname, 'w')
fout.write(header)

# TODO: This should use the AIRR python load_repertoire()
reps = yaml.safe_load(open('/work/florian.airr.yaml', 'r', encoding='utf-8'))

for r in reps['Repertoire']:
    fout.write('db.repertoire.deleteOne({"repertoire_id":"' + r['repertoire_id'] + '"});\n');
    fout.write('db.repertoire.insertOne(' + json.dumps(r) + ');\n')
fout.close()
