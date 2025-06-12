# Outputs
output "alb_dns_name" {
  description = "DNS name of the external load balancer"
  value       = aws_lb.external-alb.dns_name
}

output "igw" {
  description = "Internet Gateway"
  value       = aws_internet_gateway.internet_gateway
}
