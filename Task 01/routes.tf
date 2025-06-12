# Creating Route Table
resource "aws_route_table" "web_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Public Routing Table"
    },
  )
}

# Associating Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(var.web_subnet_cidrs)
  subnet_id      = element(aws_subnet.web_subnets[*].id, count.index)
  route_table_id = aws_route_table.web_route_table.id
}
