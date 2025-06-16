#!/usr/bin/env python3
#
# Unit tests

import unittest

from query_aws_metadata import aws_idmsv2_auth
from query_aws_metadata import aws_instance_metadata_keys
from query_aws_metadata import aws_instance_metadata

metadata_headers = aws_idmsv2_auth()
test_one = {}
test_two = {}
test_three = {}
test_one['ami-launch-index'] = '0'
test_two['instance-action'] = 'none'
test_three['instance-type'] = 't3.medium'

class TestMetadataList(unittest.TestCase):
        def test_ami_launch_index(self):
                self.assertEqual(aws_instance_metadata(metadata_headers, "ami-launch-index"), test_one)
        def test_instance_action(self):
                self.assertEqual(aws_instance_metadata(metadata_headers, "instance-action"), test_two)
        def test_instance_type(self):
                self.assertEqual(aws_instance_metadata(metadata_headers, "instance-type"), test_three)

if __name__ == "__main__":
    unittest.main(verbosity=2)
