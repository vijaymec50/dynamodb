provider "aws" {
  region = var.region
}

resource "random_pet" "this" {
  length = 2
}

locals {
  table_name = format("%s-%s-%s", var.name_prefix, var.environment, random_pet.this.id)
  table      = merge(var.table, { name = local.table_name })
}

module "dynamodb_table" {
  source = "../../wrappers/wrapper3"

  environment           = var.environment
  kms_key_arn           = var.kms_key_arn
  table_definition_path = var.table_definition_path

  nonprod_principal_arns = var.nonprod_principal_arns
  prod_principal_arns    = var.prod_principal_arns
  prod_replica_regions   = var.prod_replica_regions

  table = local.table
}
