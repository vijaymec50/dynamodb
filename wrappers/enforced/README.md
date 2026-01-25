# Environment-enforced wrapper

This wrapper enforces:
- Encryption at rest using a customer-managed KMS key (always enabled).
- Point-in-time recovery (always enabled, 35-day retention).
- Streams enabled for prod and disabled for non-prod (stream settings are not caller-configurable).
- Deletion protection disabled (not caller-configurable).
- Warm throughput disabled for non-prod and configurable only for prod.
- On-demand throughput required for non-prod, and required for prod when billing_mode is PAY_PER_REQUEST.
- Import table and global table witness are disabled (to be explored in future based on requirements).
- Non-prod (dev/sit/uat): on-demand billing and no replicas/global table.
- Prod: billing mode and replicas/global table are configurable by the caller.
- Resource-based table policy differs between non-prod and prod and is not caller-configurable.

## Usage

```hcl
module "dynamodb_table" {
  source = "tfr:///terraform-aws-modules/dynamodb-table/aws//wrappers/enforced"

  environment = "dev"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd-1234"
  table_definition_path = "table-definition.json"

  nonprod_principal_arns = [
    "arn:aws:iam::123456789012:role/app-nonprod"
  ]

  table = {
    name       = "app-dev-table"
    tags = {
      Environment = "dev"
    }
  }
}
```

## Notes

- For prod, set `prod_principal_arns` and include `table.billing_mode`, `table.read_capacity`, `table.write_capacity`, and `table.replica_regions` (or `prod_replica_regions`) as needed.
- When `table_definition_path` is set, `hash_key`, `range_key`, `attributes`, `global_secondary_indexes`, `local_secondary_indexes`, and TTL settings are loaded from that JSON. Values in `table` override the JSON if both are set.
- The resource policies are defined in `wrappers/enforced/main.tf` locals. Adjust those policy statements if your org requires different access patterns.
