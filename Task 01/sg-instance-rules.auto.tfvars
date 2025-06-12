# Instance Security Group Rules
instance_security_group = {
  rules = {
    "icmp-public-access" = {
      type                     = "ingress"
      description              = "Instance Ingress Allow ICMP ECHO from All"
      from_port                = 8
      to_port                  = 0
      protocol                 = "icmp"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      source_security_group_id = null
    }
    "http-access" = {
      type                     = "ingress"
      description              = "Instance Ingress Allow HTTP from All"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      source_security_group_id = null
    }
    "https-access" = {
      type                     = "ingress"
      description              = "Instance Ingress Allow HTTPS from All"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      source_security_group_id = null
    }
    "all" = {
      type                     = "egress"
      description              = "Instance Egress Allow to All"
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
