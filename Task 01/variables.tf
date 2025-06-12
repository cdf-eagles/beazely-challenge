# Default tags
variable "default_tags" {
  default = {
    Environment = "production"
    Owner       = "christopher.fernando"
    Project     = "Task 1"
    CostCenter  = "beazley"
    ManagedBy   = "terraform"
  }
}

variable "ssh_key_name" {
  type        = string
  description = "Default SSH key to use"
  default     = "cfernando@quicksilver_id_ed25519"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
  default     = "Beazley Task 1"
}

# Default AMI to use
variable "ami_default" {
  type        = string
  description = "Default AMI"
  default     = "ami-0a39ac0843e40d0d7"
}

variable "instance_type" {
  type        = string
  description = "Default Instance Type"
  default     = "t3a.medium"
}

variable "instance_name" {
  type        = string
  description = "Default Instance Name"
  default     = "webserver"
}

variable "instance_list" {
  type        = list(string)
  description = "Number of instances per Availability Zone"
  default     = ["01", "02", "03"]
}

variable "instance_index" {
  type        = list(string)
  description = "Index of instances per Availability Zone"
  default     = ["0", "1", "2"]
}

# Define Default Region (ensure this matches what is in provider.tf)
variable "default_region" {
  type        = string
  description = "Default AWS Region"
  default     = "us-east-2"
}

# Define Availability Zones to use
variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

# Defining CIDR Block for VPC
variable "vpc_cidr" {
  type        = string
  default     = "10.1.0.0/16"
  description = "Default CIDR Block for VPC"
}

variable "web_subnet_cidrs" {
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  description = "Web Subnet CIDRs"
}

variable "app_subnet_cidrs" {
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  description = "App Subnet CIDRs"
}

variable "db_subnet_cidrs" {
  type    = list(string)
  default = ["10.1.7.0/24", "10.1.8.0/24", "10.1.9.0/24"]
}

# Variables to assist in using for_each for dynamically created security groups.
# Consider these templates. The rule definitions are in the *.auto.tfvars files.
variable "vpc_security_group_rules" {
  description = "The security group rules for the VPC"
  type = object({
    ingress = optional(map(object({
      cidr_ipv4                    = string
      cidr_ipv6                    = string
      from_port                    = number
      to_port                      = number
      ip_protocol                  = string
      prefix_list_id               = string
      referenced_security_group_id = string
    })), {})
    egress = optional(map(object({
      cidr_ipv4                    = string
      cidr_ipv6                    = string
      from_port                    = number
      to_port                      = number
      ip_protocol                  = string
      prefix_list_id               = string
      referenced_security_group_id = string
    })), {})
  })
}

variable "instance_security_group" {
  description = "The security group rules for an Instance"
  type = object({
    rules = optional(map(object({
      type                     = string
      from_port                = number
      to_port                  = number
      protocol                 = string
      description              = string
      cidr_blocks              = list(string)
      ipv6_cidr_blocks         = list(string)
      prefix_list_ids          = list(string)
      source_security_group_id = string
    })), {})
  })
}

variable "db_security_group" {
  description = "The security group rules for a Database Server"
  type = object({
    rules = optional(map(object({
      type                     = string
      from_port                = number
      to_port                  = number
      protocol                 = string
      description              = string
      cidr_blocks              = list(string)
      ipv6_cidr_blocks         = list(string)
      prefix_list_ids          = list(string)
      source_security_group_id = string
    })), {})
  })
}

variable "lb_listeners" {
  default = [
    {
      protocol    = "TCP"
      target_port = "80"
      health_port = "80"
    },
    {
      protocol    = "TCP"
      target_port = "443"
      health_port = "443"
    }
  ]
}
