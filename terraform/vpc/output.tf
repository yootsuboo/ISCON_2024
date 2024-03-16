# vpc
output "vpc_id" {
  value = module.vpc.vpc_id
}

# public subnets
output "public_subnets" {
  description = "list IDs"
  value       = module.vpc.public_subnets
}

output "public_route_table_ids" {
  description = "list IDs"
  value       = module.vpc.public_route_table_ids
}

# private subnets
output "private_subnets" {
  description = "list IDs"
  value       = module.vpc.private_subnets
}

output "private_route_table_ids" {
  description = "list IDs"
  value       = module.vpc.private_route_table_ids
}

# database subnets
output "database_subnets" {
  description = "list IDs"
  value       = module.vpc.database_subnets
}

output "database_route_table_ids" {
  description = "list IDs"
  value       = module.vpc.database_route_table_ids
}

