variable "environment" {
  description = "Deployment environment (dev, sit, uat, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "sit", "uat", "prod"], lower(var.environment))
    error_message = "environment must be one of: dev, sit, uat, prod."
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN used for DynamoDB encryption at rest."
  type        = string
}

variable "nonprod_principal_arns" {
  description = "IAM principal ARNs allowed by the enforced non-prod table policy."
  type        = list(string)
  default     = []

  validation {
    condition     = lower(var.environment) == "prod" || length(var.nonprod_principal_arns) > 0
    error_message = "nonprod_principal_arns must be set for dev/sit/uat environments."
  }
}

variable "prod_principal_arns" {
  description = "IAM principal ARNs allowed by the enforced prod table policy."
  type        = list(string)
  default     = []

  validation {
    condition     = lower(var.environment) != "prod" || length(var.prod_principal_arns) > 0
    error_message = "prod_principal_arns must be set for prod environments."
  }
}

variable "prod_replica_regions" {
  description = "Replica regions used by default in prod when table.replica_regions is not set."
  type        = any
  default     = []

  validation {
    condition = lower(var.environment) != "prod" || length(try(var.table.replica_regions, [])) > 0 || length(var.prod_replica_regions) > 0
    error_message = "For prod, set table.replica_regions or prod_replica_regions to enable the default global table/replicas."
  }
}

variable "table" {
  description = "Table configuration passed to the base module, excluding enforced settings."
  type        = any
  default     = {}

  validation {
    condition     = !contains(["dev", "sit", "uat"], lower(var.environment)) || try(length(var.table.warm_throughput), 0) == 0
    error_message = "warm_throughput is only allowed in prod environments."
  }

  validation {
    condition = contains(["dev", "sit", "uat"], lower(var.environment)) ? (
      try(length(var.table.on_demand_throughput), 0) > 0
    ) : (
      upper(try(var.table.billing_mode, "PAY_PER_REQUEST")) == "PAY_PER_REQUEST" ?
      try(length(var.table.on_demand_throughput), 0) > 0 :
      true
    )
    error_message = "on_demand_throughput must be set for non-prod, and for prod when billing_mode is PAY_PER_REQUEST."
  }

  validation {
    condition     = try(length(var.table.import_table), 0) == 0
    error_message = "import_table is not supported in this wrapper."
  }

  validation {
    condition     = try(var.table.global_table_witness, null) == null
    error_message = "global_table_witness is not supported in this wrapper."
  }
}

variable "table_definition_path" {
  description = "Path to a JSON file defining hash/range keys, attributes, and GSIs."
  type        = string
  default     = null
}
