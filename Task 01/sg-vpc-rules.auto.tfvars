# VPC Security Group Rules
vpc_security_group_rules = {
  ingress = {
    "http-access" = {
      from_port                    = 80
      to_port                      = 80
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "0.0.0.0/0"
      cidr_ipv6                    = null
      prefix_list_id               = null
      referenced_security_group_id = null
    }
    "https-access" = {
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      cidr_ipv4                    = "0.0.0.0/0"
      cidr_ipv6                    = null
      prefix_list_id               = null
      referenced_security_group_id = null
    }
  }
  egress = {
    "all" = {
      from_port                    = -1
      to_port                      = -1
      ip_protocol                  = -1
      cidr_ipv4                    = "0.0.0.0/0"
      cidr_ipv6                    = null
      prefix_list_id               = null
      referenced_security_group_id = null
    }
  }
}
