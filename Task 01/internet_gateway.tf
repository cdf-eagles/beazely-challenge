# Creating Internet Gateway 
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Internet Gateway"
    },
  )
}
