# Database Server Security Group Rules
db_security_group = {
  rules = {
    "icmp-public-access" = {
      type                     = "ingress"
      description              = "Database Server Ingress Allow ICMP ECHO from All"
      from_port                = 8
      to_port                  = 0
      protocol                 = "icmp"
      cidr_blocks              = ["10.1.0.0/16"]
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      source_security_group_id = null
    }
    "mysql-access" = {
      type                     = "ingress"
      description              = "Database Server Ingress Allow MySQL from VPC"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      cidr_blocks              = ["10.1.0.0/16"]
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      source_security_group_id = null
    }
    "all" = {
      type                     = "egress"
      description              = "Database Server Egress Allow to All"
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      source_security_group_id = null
    }
  }
}
