# Task 1

## A 3-tier architecture is a common setup. Use a tool of your choosing/familiarity to create these.

### Proposed Solution
Terraform to build instances in 3 AZs within AWS, with an Application load balancer in front of the web servers and RDS as the backend database. No Application servers are included in this configuration (for simplicity), but subnets/security groups are provisioned for their use. Application Server instances would be configured similar to the web servers.

## NFR’s: There must always be 3 UP instances / containers within a cloud architecture of 3 zones (a/b/c). Please indicate within your solution how you would achieve this

### Proposed Solution (not implemented)
I feel like this would require deploying in something like EKS (or ECS), to utilize Containers/Kubernetes to ensure containers were always up in pods, but as I'm not as familiar with ECS/EKS, I did not implement this solution.

## Solution implemented using OpenTofu+1Password
See file [tofu-plan-output.script](tofu-plan-output.script) for output of `op run --env-file=op.env -- tofu plan -out=tfplan`.

For a production environment I would do a lot more and research ECS/EKS for deployment. I re-used a lot of my existing terraform/tofu code from my personal AWS infrastructure for this task.
