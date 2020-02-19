#
# This script is VDJServer specific.
# This script is specific to this dataset.
#
# We do not want to commit large data files into the
# github repository, so we download from VDJServer
# Community Data Portal.
#

import requests
import os

directory='/mnt/data/florian'
vdjserver_api='https://vdjserver.org/api/v1'

# The VDJServer public project uuid
project='531076969703215591-242ac11c-0001-012'

# The B-cell and T-cell rearrangements are different downloads
bcell_file='6538565024404270615-242ac119-0001-012'
bcell_job='6414d653-edd2-4d26-be1d-98a82f5e9c98-007'
tcell_file='2478797497345708521-242ac119-0001-012'
tcell_job='d097e851-c2ac-4bc9-89ca-93845f3cfbc0-007'

def download_file(project_uuid, file_uuid, filename):
    print(filename)
    url = vdjserver_api + '/projects/' + project_uuid + '/postit/' + file_uuid
    print(url)
    resp = requests.get(url)
    resp.raise_for_status()
    obj = resp.json()
    print(obj)
    href = obj['result']['_links']['self']['href']
    print(href)
    with requests.get(href, stream=True) as r:
        r.raise_for_status()
        print("Downloading: " + href)
        with open(filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192): 
                if chunk: # filter out keep-alive new chunks
                    f.write(chunk)
                    # f.flush()
    return filename

# B-cell data
# generate posit then download data
download_file(project, bcell_file, directory + '/data.zip')
os.system("cd " + directory + " && unzip " + direcotry + "/data.zip")
os.system("rm -f " + directory + "/data.zip")
os.system("cd " + directory + "/" + bcell_job + " && ls *.airr.tsv.zip | xargs -n 1 unzip")
os.system("chmod -R a+rw " + directory + "/" + bcell_job);

# T-cell data
# generate posit then download data
download_file(project, tcell_file, direcotry + '/data.zip')
os.system("cd " + directory + " && unzip " + directory + "/data.zip")
os.system("rm -f " + directory + "/data.zip")
os.system("cd " + directory + "/" + tcell_job + " && ls *.airr.tsv.zip | xargs -n 1 unzip")
os.system("chmod -R a+rw " + directory + "/" + tcell_job);
