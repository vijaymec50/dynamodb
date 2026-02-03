# Environment-enforced wrapper (registry module source)

This wrapper mirrors `wrappers/enforced`, but it references the public module source
`terraform-aws-modules/dynamodb-table/aws` directly.

## Usage

```hcl
module "dynamodb_table" {
  source = "./wrappers/wrapper3"

  environment = "dev"
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd-1234"
  table_definition_path = "table-definition.json"

  nonprod_principal_arns = [
    "arn:aws:iam::123456789012:role/app-nonprod"
  ]

  table = {
    tags = {
      Environment = "dev"
    }
  }
}
```

## Notes

- Encryption at rest, PITR, stream settings, and deletion protection are enforced.
- Warm throughput is allowed only in prod.
- On-demand throughput is required for non-prod and for prod when billing_mode is PAY_PER_REQUEST.
- Import table and global table witness are disabled. These features will be explored in future based on requirements.
- When `table_definition_path` is set, `hash_key`, `range_key`, `attributes`, `global_secondary_indexes`,
  `local_secondary_indexes`, and TTL settings are loaded from that JSON. Values in `table` override the JSON if both are set.
