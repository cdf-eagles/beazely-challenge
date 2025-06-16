#!/usr/bin/env python3
#
# python script that takes a nested object and returns the value of the user-supplied key

import argparse
import json

FILENAME = "./input2.txt"
FILECONTENTS = ""

parser = argparse.ArgumentParser(
        prog='task3.py',
        description='returns the value of a user-supplied key for a nested object',
        epilog='Task 3 of the Beazley Challenge'
)

subparsers = parser.add_subparsers(dest="subcommand")

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

def generic_object(dict_or_list):
        if type(dict_or_list) is dict:
                return dict_or_list.items()
        if type(dict_or_list) is list:
                return enummerate(dict_or_list)

def query_data(d, search):
        """
        Query the supplied filename with the supplied key and return the object. This is a recursive search.

        Inputs: dictionary to search, key to query (filename is a global variable)
        Outputs: found object
        """
        try:
                result = []
                for key, value in generic_object(d):
                        if key == search:
                                return value
                        elif type(value) is dict or type(value) is list:
                                return query_data(value, search)
                return result

        except Exception as e:
                return {
                        "error": "Unexpected error: " + str(e),
                }

@subcommand([argument("-k", "--key", action="store", help="Get value of nested object from specified key")])
def getkey(args):
        try:
                print(query_data(eval(FILE_CONTENTS), args.key))

        except Exception as e:
                return {
                        "error": "Unexpected error: " + str(e)
                }

if __name__ == '__main__':
        try:
                with open(FILENAME, "rt") as f:
                        FILE_CONTENTS = f.read()
                f.close()
                args = parser.parse_args()
                if args.subcommand is None:
                        parser.print_help()
                else:
                        args.func(args)
        except argparse.ArgumentError as e:
                print("error: Argparse argument error: " + str(e))
        except argparse.ArgumentTypeError as e:
                print("error: Argparse argument type error: " + str(e))
