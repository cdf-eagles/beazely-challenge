# Task 2

## Create a script that will query the meta data of an instance within a cloud provider of your choice and provide a JSON formatted output. The choice of language and implementation is up to you.

### Proposed Solution:
Python script run from an EC2 instsance to query the AWS IDMSv2 service.

## NFR’s: Your code allows for a particular data key to be retrieved individually, and unit testing is expected to be included.

### Proposed Solution:
Implment Python's unittest to test the code.

## Solution implemented
See file [query_aws_metadata.py](query_aws_metadata.py) for Python script that queries IDMSv2 service. This python script requires argparse, requests, and json Python libraries.

Unfortunately, I was not able to get unit tests to work.

See [task2.script](task2.script) for test output.
