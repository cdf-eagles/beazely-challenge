# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} VPC"
    },
  )
}
