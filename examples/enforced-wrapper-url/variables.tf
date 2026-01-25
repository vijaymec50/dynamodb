variable "environment" {
  description = "Deployment environment (dev, sit, uat, prod)."
  type        = string
}

variable "region" {
  description = "AWS region for the example."
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for the example table name."
  type        = string
  default     = "example-dynamodb"
}

variable "kms_key_arn" {
  description = "KMS key ARN used for DynamoDB encryption at rest."
  type        = string
}

variable "table_definition_repo" {
  description = "GitHub repository in owner/repo format for the public table definition."
  type        = string
}

variable "table_definition_path" {
  description = "Path to the table definition JSON file in the repo."
  type        = string
}

variable "nonprod_principal_arns" {
  description = "IAM principal ARNs allowed by the enforced non-prod table policy."
  type        = list(string)
  default     = []
}

variable "prod_principal_arns" {
  description = "IAM principal ARNs allowed by the enforced prod table policy."
  type        = list(string)
  default     = []
}

variable "prod_replica_regions" {
  description = "Replica regions used by default in prod when table.replica_regions is not set."
  type        = any
  default     = []
}

variable "table" {
  description = "Table configuration passed to the wrapper."
  type        = any
  default     = {}
}
