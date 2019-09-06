This directory contains a testing code suite for the ADC API

# Testing approach

- Python code to run a single test
- Bash script to run a suite of tests and report results.

## Test subdirectories

There are two subdirectories in the base level of this github repository, one each for tests against the /repertoire endpoint and the /rearrangement
endpoint. In each subdirectory, files are named with respect to whether the test is expected to pass or
fail, with the file name including a hint at what the test is testing against.

## Running the python test application

The python code can be run as follows:
```
$ python test_airr_api.py https://airr-api.ireceptor.org/airr/v1 repertoire repertoire/pass-all.json
PASS: Query file repertoire/pass-all.json to https://airr-api.ireceptor.org/airr/v1/repertoire OK
```
Required command line options consist of:
- The base URL to test against
- The entry point to test
- The JSON query to execute

Optional command line arguments are:
- -v: Run in verbose mode, provided more diagnostics as to what occurred.
- -f: Force queries to run in error conditions. For example, the code tests for bad JSON on query file load, but in some instances you want to test that the service running the API can detect and handle the bad JSON code. -f will force the bad JSON to be sent to the service rather than detecting it as bad JSON and exiting.
- -h Print a help message.

```
$ python test_airr_api.py -h
usage: test_airr_api.py [-h] [-f] [-v] base_url entry_point query_file

positional arguments:
  base_url
  entry_point
  query_file

optional arguments:
  -h, --help     show this help message and exit
  -f, --force    Force sending bad JSON even when the JSON can't be loaded.
  -v, --verbose  Run the program in verbose mode.
```

## Running the test suite

The bash script ADCTest uses the python code above to run a set of tests against a given API. The
command line arguments to the code are similar, with the two following exceptions:
- A list of files can be given as a suite of tests to run
- The -v and -f command line arguments can be interspersed between the file to turn on and off the verbosity and force flags.

```
$ ./ADCtest.sh https://vdjserver.org/airr/v1 repertoire repertoire/pass*.json

Running test repertoire/pass-all.json
PASS: Query file repertoire/pass-all.json to https://vdjserver.org/airr/v1/repertoire OK

Running test repertoire/pass-organism-id.json
PASS: Query file repertoire/pass-organism-id.json to https://vdjserver.org/airr/v1/repertoire OK

Running test repertoire/pass-pcr_target_locus.json
PASS: Query file repertoire/pass-pcr_target_locus.json to https://vdjserver.org/airr/v1/repertoire OK

Running test repertoire/pass-query2_repertoire.json
PASS: Query file repertoire/pass-query2_repertoire.json to https://vdjserver.org/airr/v1/repertoire OK

SUMMARY: All tests passed!!!
```

## Requirements

The python code requires the following python modules:

- urllib
- argparse
- json
- ssl
- normal system modules (os, sys, time)

