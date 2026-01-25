data "http" "table_definition" {
  url = local.table_definition_url
}

locals {
  environment = lower(var.environment)
  is_nonprod  = contains(["dev", "sit", "uat"], local.environment)
  is_prod     = local.environment == "prod"

  table_definition_branch_map = {
    dev  = "Dev"
    sit  = "SIT"
    uat  = "UAT"
    prod = "master"
  }
  table_definition_branch = local.table_definition_branch_map[local.environment]
  table_definition_url = format(
    "https://raw.githubusercontent.com/%s/%s/%s",
    var.table_definition_repo,
    local.table_definition_branch,
    trim(var.table_definition_path, "/")
  )

  enforced_billing_mode        = local.is_nonprod ? "PAY_PER_REQUEST" : try(var.table.billing_mode, "PAY_PER_REQUEST")
  enforced_read_capacity       = local.is_nonprod ? null : try(var.table.read_capacity, null)
  enforced_write_capacity      = local.is_nonprod ? null : try(var.table.write_capacity, null)
  enforced_autoscaling_enabled = local.is_nonprod ? false : coalesce(try(var.table.autoscaling_enabled, null), false)
  enforced_replica_regions     = local.is_nonprod ? [] : try(var.table.replica_regions, var.prod_replica_regions)
  enforced_stream_enabled      = local.is_prod
  enforced_stream_view_type    = local.is_prod ? "NEW_AND_OLD_IMAGES" : null
  enforced_on_demand_throughput = try(var.table.on_demand_throughput, {})
  enforced_warm_throughput      = local.is_nonprod ? {} : try(var.table.warm_throughput, {})

  resource_policy_nonprod = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "NonProdTableAccess"
        Effect    = "Allow"
        Principal = { AWS = var.nonprod_principal_arns }
        Action    = ["dynamodb:*"]
        Resource  = "__DYNAMODB_TABLE_ARN__"
      }
    ]
  })

  resource_policy_prod = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "ProdTableAccess"
        Effect    = "Allow"
        Principal = { AWS = var.prod_principal_arns }
        Action    = ["dynamodb:*"]
        Resource  = "__DYNAMODB_TABLE_ARN__"
      }
    ]
  })

  table_definition = jsondecode(data.http.table_definition.response_body)
}

module "this" {
  source = "../"

  create_table                          = try(var.table.create_table, true)
  name                                  = try(var.table.name, null)
  attributes                            = try(var.table.attributes, local.table_definition.attributes, [])
  hash_key                              = try(var.table.hash_key, local.table_definition.hash_key, null)
  range_key                             = try(var.table.range_key, local.table_definition.range_key, null)
  billing_mode                          = local.enforced_billing_mode
  read_capacity                         = local.enforced_read_capacity
  write_capacity                        = local.enforced_write_capacity
  stream_enabled                        = local.enforced_stream_enabled
  stream_view_type                      = local.enforced_stream_view_type
  table_class                           = try(var.table.table_class, null)
  deletion_protection_enabled           = false
  region                                = try(var.table.region, null)
  restore_date_time                     = try(var.table.restore_date_time, null)
  restore_source_name                   = try(var.table.restore_source_name, null)
  restore_source_table_arn              = try(var.table.restore_source_table_arn, null)
  restore_to_latest_time                = try(var.table.restore_to_latest_time, null)
  ttl_enabled                           = try(var.table.ttl_enabled, local.table_definition.ttl_enabled, false)
  ttl_attribute_name                    = try(var.table.ttl_attribute_name, local.table_definition.ttl_attribute_name, "")
  point_in_time_recovery_enabled        = true
  point_in_time_recovery_period_in_days = 35
  global_secondary_indexes              = try(var.table.global_secondary_indexes, local.table_definition.global_secondary_indexes, [])
  local_secondary_indexes               = try(var.table.local_secondary_indexes, local.table_definition.local_secondary_indexes, [])
  replica_regions                       = local.enforced_replica_regions
  global_table_witness                  = null
  tags                                  = try(var.table.tags, {})
  timeouts                              = try(var.table.timeouts, null)
  autoscaling_enabled                   = local.enforced_autoscaling_enabled
  autoscaling_defaults                  = try(var.table.autoscaling_defaults, null)
  autoscaling_read                      = try(var.table.autoscaling_read, {})
  autoscaling_write                     = try(var.table.autoscaling_write, {})
  autoscaling_indexes                   = try(var.table.autoscaling_indexes, {})
  import_table                          = {}
  ignore_changes_global_secondary_index = try(var.table.ignore_changes_global_secondary_index, false)
  on_demand_throughput                  = local.enforced_on_demand_throughput
  warm_throughput                       = local.enforced_warm_throughput

  server_side_encryption_enabled     = true
  server_side_encryption_kms_key_arn = var.kms_key_arn
  resource_policy                   = local.is_prod ? local.resource_policy_prod : local.resource_policy_nonprod
}
