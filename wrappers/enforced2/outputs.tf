output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.this.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table."
  value       = module.this.dynamodb_table_id
}

output "dynamodb_table_stream_arn" {
  description = "ARN of the table stream."
  value       = module.this.dynamodb_table_stream_arn
}

output "dynamodb_table_stream_label" {
  description = "Stream label of the table."
  value       = module.this.dynamodb_table_stream_label
}

output "dynamodb_table_replicas" {
  description = "Map of table replicas by region."
  value       = module.this.dynamodb_table_replicas
}

output "dynamodb_table_replica_arns" {
  description = "Map of replica ARNs by region."
  value       = module.this.dynamodb_table_replica_arns
}

output "dynamodb_table_replica_stream_arns" {
  description = "Map of replica stream ARNs by region."
  value       = module.this.dynamodb_table_replica_stream_arns
}

output "dynamodb_table_replica_stream_labels" {
  description = "Map of replica stream labels by region."
  value       = module.this.dynamodb_table_replica_stream_labels
}
