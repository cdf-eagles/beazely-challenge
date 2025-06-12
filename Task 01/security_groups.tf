# VPC security group and rules
resource "aws_security_group" "default_vpc_sg" {
  name        = "default-vpc-sg"
  description = "${var.vpc_name} Default VPC Security Group"
  vpc_id      = aws_vpc.vpc.id

  # ingress = []
  # egress  = []

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Default VPC Security Group"
    },
  )
}

# Instance security groups and rules
resource "aws_security_group" "default_instance_sg" {
  name        = "default-instance-sg"
  description = "${var.vpc_name} Default Instance Security Group"
  vpc_id      = aws_vpc.vpc.id

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Default Instance Security Group"
    },
  )
}

# Database Server security groups and rules
resource "aws_security_group" "default_db_sg" {
  name        = "default-db-sg"
  description = "${var.vpc_name} Default Database Server Security Group"
  vpc_id      = aws_vpc.vpc.id

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Default Database Server Security Group"
    },
  )
}

# Create VPC Security Group Rules dynamically from sg-vpc-rules.auto-tfvars
resource "aws_vpc_security_group_ingress_rule" "allow_vpc_ingress_rules" {
  for_each = var.vpc_security_group_rules.ingress

  security_group_id            = aws_security_group.default_vpc_sg.id
  description                  = "${var.vpc_name} VPC Ingress - Port ${each.value.to_port}"
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

resource "aws_vpc_security_group_egress_rule" "allow_vpc_egress_rules" {
  for_each = var.vpc_security_group_rules.egress

  security_group_id            = aws_security_group.default_vpc_sg.id
  description                  = "${var.vpc_name} VPC Egress - Port ${each.value.to_port}"
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = try(each.value.cidr_ipv4, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6, null)
  prefix_list_id               = try(each.value.prefix_list_id, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id, null)
}

# Create Instance Security Group Rules dynamically from sg-instance-rules.auto-tfvars
resource "aws_security_group_rule" "allow_instance_rules" {
  for_each = var.instance_security_group.rules

  security_group_id        = aws_security_group.default_instance_sg.id
  description              = try(each.value.description, "${var.vpc_name} Instance ${each.value.type} - port ${each.value.to_port}")
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}

# Database Security Groups
resource "aws_security_group_rule" "allow_db_rules" {
  for_each = var.db_security_group.rules

  security_group_id        = aws_security_group.default_db_sg.id
  description              = try(each.value.description, "${var.vpc_name} Database ${each.value.type} - port ${each.value.to_port}")
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}
