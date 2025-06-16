#!/usr/bin/env python3
#
# python script that queries an AWS instance's metadata and outputs in JSON format

import argparse
import requests
import json

BASE_URL = "http://169.254.169.254/latest"

parser = argparse.ArgumentParser(
        prog='query_aws_metadata.py',
        description='query the meta data of an instance within AWS and provide a JSON formatted output',
        epilog='Task 2 of the Beazley Challenge'
)
subparsers = parser.add_subparsers(dest="subcommand")
#parser.add_argument("-k", "--metadata-key", help = "AWS EC2 Metadata Key")
#parser.add_argument("-l", "--list-keys", action='store_const', help = "Available AWS EC2 Metadata Keys")

# Subcommand functions taken from https://gist.github.com/mivade/384c2c41c3a29c637cb6c603d4197f9f
def argument(*name_or_flags, **kwargs):
        """
        Function to properly format arguments to pass to the subcommand decorator defined below.

        Inputs: The name or flags of the intended subcommand function, arguments for the intended subcommand
        Outputs: list of the subcommand/command line options, arguments
        """
        return (list(name_or_flags), kwargs)

def subcommand(args=[], parent=subparsers):
        """
        Decorator function for parsing subcommands with argparse

        Inputs: wrapped function, arguments for each subcommand
        Outputs: function for the subcommand
        """
        def decorator(func):
                parser = parent.add_parser(func.__name__, description=func.__doc__)
                for arg in args:
                        parser.add_argument(*arg[0], **arg[1])
                parser.set_defaults(func=func)
        return decorator

# Used https://github.com/HadarNeu/DevSecOps-Python/blob/main/ec2-metadata-automation.py as a guide
def aws_idmsv2_auth():
        """
        Authenticate with the AWS IDMSv2 service

        This function creates an IDMSv2 session, which is required to access metadata.

        Equivalent to this command:
            export TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

        Inputs: None
        Outputs: dict of HTTP headers, HTTP status code
        """
        try:
                # Obtain a session token (6 hour TTL)
                token_url = BASE_URL + "/api/token"
                token_headers = {'X-aws-ec2-metadata-token-ttl-seconds': '21600'} 

                token_response = requests.put(token_url, headers=token_headers, timeout=5)

                if token_response.status_code != 200:
                        return {
                                "error": "Failed to retrieve token",
                                "status_code":  token_response.status_code
                        }, 500
                
                token = token_response.text

                # Create HTTP headers for future requests
                metadata_headers = {"X-aws-ec2-metadata-token": token}

                return metadata_headers, token_response.status_code
        except requests.exceptions.RequestException as e:
                return {
                        "error": "Failed to authenticate: " + str(e),
                        "details": "This script must be run from an AWS EC2 instance"
                }, 500
        except Exception as e:
                return {
                        "error": "Unexpected error: " + str(e),
                }, 500

def aws_instance_metadata(metadata_headers, metadata_key):
        """
        Fetch the metadata of an AWS EC2 instance with the provided 'metadata_key'.

        Inputs: dict of HTTP headers, string containing an EC2 metadata key
        Outputs: metadata for the supplied key(s)
        """
        try:
                metadata = {}
                if metadata_key == "all":
                        keys = aws_instance_metadata_keys(metadata_headers).split()
                        for key in keys:
                                if not key.endswith('/'):
                                        metadata_response = requests.get(BASE_URL + "/meta-data/" + key, headers=metadata_headers, timeout=5)
                                        if metadata_response.status_code != 200:
                                                return {
                                                        "error": "Failed to fetch metadata",
                                                        "status_code": metadata_response.status_code
                                                }, 500
                                        metadata[key] = metadata_response.text
                else:
                        metadata_response = requests.get(BASE_URL + "/meta-data/" + metadata_key, headers=metadata_headers, timeout=5)
                        if metadata_response.status_code != 200:
                                return {
                                        "error": "Failed to fetch metadata",
                                        "status_code": metadata_response.status_code
                                }, 500
                        metadata[metadata_key] = metadata_response.text
                
                return metadata
        except requests.exceptions.RequestException as e:
                return {
                        "error": "Failed to request data :" + str(e)
                }, 500
        except Exception as e:
                return {
                        "error": "Unexpected error: " + str(e),
                }, 500

def aws_instance_metadata_keys(metadata_headers):
        """
        List the available metadata keys available with the IDMWv2 service

        Equivalent to this command line:
                curl -H "X-aws-ec2-metadata-token: ${TOKEN}" -s http://169.254.169.254/latest/meta-data/

        Inputs: dict of HTTP headers
        Outputs: list of metadata keys
        """
        try:
                keys_response = requests.get(BASE_URL + "/meta-data", headers=metadata_headers, timeout=5)

                if keys_response.status_code != 200:
                        return {
                                "error": "Failed to fetch metadata keys",
                                "status_code": keys_response.status_code
                        }, 500
                
                return keys_response.text
        except requests.exceptions.RequestException as e:
                return {
                        "error": "Failed to request data :" + str(e)
                }, 500
        except Exception as e:
                return {
                        "error": "Unexpected error: " + str(e),
                }, 500

@subcommand([argument("-l", "--listkeys", help="List available EC2 Instance metadata keys")])
def listkeys(args):
        try:
                metadata_headers, status_code = aws_idmsv2_auth()
                if status_code != 200:
                        return {
                                "error": "Failed to obtain auth token",
                                "status_code": status_code
                        }
                metadata_keys = aws_instance_metadata_keys(metadata_headers).split()
                print(json.dumps(metadata_keys, indent=4))
        except Exception as e:
                return {
                        "error": "Unexpected error: " + str(e)
                }, 500

@subcommand([argument("-k", "--key", action="store", default="all", help="Get specified EC2 Instance metadata key [default: all (all metadata)]")])
def getkey(args):
        try:
                key = args.key
                metadata_headers, status_code = aws_idmsv2_auth()

                if status_code != 200:
                        return {
                                "error": "Failed to obtain auth token",
                                "status_code": status_code
                        }
                metadata = aws_instance_metadata(metadata_headers, key)
                print(json.dumps(metadata, indent=4))
        except Exception as e:
                return {
                        "error": "Unexpected error: " + str(e)
                }, 500

if __name__ == '__main__':
        try:
                args = parser.parse_args()
                if args.subcommand is None:
                        parser.print_help()
                else:
                        args.func(args)
        except argparse.ArgumentError as e:
                print("error: Argparse argument error: " + str(e))
        except argparse.ArgumentTypeError as e:
                print("error: Argparse argument type error: " + str(e))
