# Web Tier Subnets
resource "aws_subnet" "web_subnets" {
  count             = length(var.web_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.web_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Web Subnet ${count.index + 1}"
    },
  )
}

# App Tier Subnets
resource "aws_subnet" "app_subnets" {
  count             = length(var.app_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.app_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} App Subnet ${count.index + 1}"
    },
  )
}

# DB Tier Subnets
resource "aws_subnet" "db_subnets" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.db_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} DB Subnet ${count.index + 1}"
    },
  )
}
