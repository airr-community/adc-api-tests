import urllib.request, urllib.parse
import argparse
import json
import os, ssl
import sys
import time

def processQuery(query_url, header_dict, query_dict={}, verbose=False, force=False):
    # Build the required JSON data for the post request. The user
    # of the function provides both the header and the query data

    # Convert the query dictionary to JSON
    query_json = json.dumps(query_dict)

    # Encode the JSON for the HTTP requqest
    query_json_encoded = query_json.encode('utf-8')

    # Try to connect the URL and get a response. On error return an
    # empty JSON array.
    try:
        # Build the request
        request = urllib.request.Request(query_url, query_json_encoded, header_dict)
        # Make the request and get a handle for the response.
        response = urllib.request.urlopen(request)
        # Read the response
        url_response = response.read()
        # If we have a charset for the response, decode using it, otherwise assume utf-8
        if not response.headers.get_content_charset() is None:
            url_response = url_response.decode(response.headers.get_content_charset())
        else:
            url_response = url_response.decode("utf-8")

    except urllib.error.HTTPError as e:
        print('ERROR: Server could not fullfil the request to ' + query_url)
        print('ERROR: Error code = ' + str(e.code) + ', Message = ', e.read())
        return json.loads('[]')
    except urllib.error.URLError as e:
        print('ERROR: Failed to reach the server')
        print('ERROR: Reason =', e.reason)
        return json.loads('[]')
    except Exception as e:
        print('ERROR: Unable to process response')
        print('ERROR: Reason =' + str(e))
        return json.loads('[]')

    # Convert the response to JSON so we can process it easily.
    try:
        json_data = json.loads(url_response)
    except json.decoder.JSONDecodeError as error:
        if force:
            print("WARNING: Unable to process JSON response: " + str(error))
            return json_data
        else:
            print("ERROR: Unable to process JSON response: " + str(error))
            if verbose:
                print("ERROR: JSON = " + url_response)
            return json.loads('[]')
    except Exception as error:
        print("ERROR: Unable to process JSON response: " + str(error))
        if verbose:
            print("ERROR: JSON = " + url_response)
        return json.loads('[]')

    # Return the JSON data
    return json_data

def getHeaderDict():
    # Set up the header for the post request.
    header_dict = {'accept': 'application/json',
                   'Content-Type': 'application/json'}
    return header_dict

def initHTTP():
    # Deafult OS do not have create cient certificate bundles. It is
    # easiest for us to ignore HTTPS certificate errors in this case.
    if (not os.environ.get('PYTHONHTTPSVERIFY', '') and
        getattr(ssl, '_create_unverified_context', None)): 
        ssl._create_default_https_context = ssl._create_unverified_context

def testAPI(base_url, entry_point, query_files, verbose, force):
    # Ensure our HTTP set up has been done.
    initHTTP()
    # Get the HTTP header information (in the form of a dictionary)
    header_dict = getHeaderDict()

    # Build the full URL combining the URL and the entry point.
    query_url = base_url+'/'+entry_point

    # Iterate over the query files
    for query_file in query_files:
        # Open the JSON query file and read it as a python dict.
        try:
            with open(query_file, 'r') as f:
                query_dict = json.load(f)
        except IOError as error:
            print("ERROR: Unable to open JSON file " + query_file + ": " + str(error))
            return 1
        except json.JSONDecodeError as error:
            if force:
                print("WARNING: JSON Decode error detected in " + query_file + ": " + str(error))
                with open(query_file, 'r') as f:
                    query_dict = f.read().replace('\n', '')
            else:
                print("ERROR: JSON Decode error detected in " + query_file + ": " + str(error))
                return 1
        except Exception as error:
            print("ERROR: Unable to open JSON file " + query_file + ": " + str(error))
            return 1
            
        if verbose:
            print('INFO: Performing query: ' + str(query_dict))

        # Perform the query.
        query_json = processQuery(query_url, header_dict, query_dict, verbose, force)
        if verbose:
            print('INFO: Query response: ' + str(query_json))

        # Print out an error if the query failed.
        if len(query_json) == 0:
            print('ERROR: Query file ' + query_file + ' to ' + query_url + ' failed')
            return 1

        # Check for a correct Info object.
        if not "Info" in query_json:
            print("ERROR: Expected to find an 'Info' object, none found")
            return 1

        if entry_point == "rearrangement":
            response_tag = "Rearrangement"
        elif entry_point == "repertoire":
            response_tag = "Repertoire"
        else:
            print("ERROR: I don't know how to check a '" + entry_point + "' API entry_point")
            return 1

        if not response_tag in query_json:
            print("ERROR: Expected to find a '" + response_tag +"' object, none found")
            return 1
        
        query_response_array = query_json[response_tag]
        num_responses = len(query_response_array)
        print("INFO: Received " + str(num_responses) + " " + entry_point + "s from query")

        # Check for the correct type of response data depending on entry point
        #if 
        # Extract the "Rearrangement" component of the JSON response.
        #rearrangement_json = query_json["Rearrangement"]
        # Because we aggregated via repertoire_id, we need to iterate over the
        # repertoires returned and sum up their count.
        #total = 0
        #for repertoire in rearrangement_json:
        #   total = total + repertoire['count']
        # Store the total value in our data dictionary for this key.
        #data.update({value:total})
        #graph_total = graph_total + total
        #print("Total for " + query_key + "/" + value + " = " + str(total))
        print('PASS: Query file ' + query_file + ' to ' + query_url + ' OK')

    return 0

def getArguments():
    # Set up the command line parser
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=""
    )

    # The URL for the repository to test
    parser.add_argument("base_url")
    # The API entry point to use
    parser.add_argument("entry_point")
    # Comma separated list of query files to test.
    parser.add_argument("query_files")
    # Force JSON load flag
    parser.add_argument(
        "-f",
        "--force",
        action="store_const",
        const=True,
        help="Force sending bad JSON even when the JSON can't be loaded.")
    # Verbosity flag
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Run the program in verbose mode.")

    # Parse the command line arguements.
    options = parser.parse_args()
    return options


if __name__ == "__main__":
    # Get the command line arguments.
    options = getArguments()
    # Split the comma separated input string.
    query_files = options.query_files.split(',')
    # Perform the query analysis, gives us back a dictionary.
    error_code = testAPI(options.base_url, options.entry_point, query_files, options.verbose, options.force)
    # Return success
    sys.exit(error_code)

