# Environment-enforced wrapper (public URL table definition)

This wrapper enforces the same controls as `wrappers/enforced` but loads the table definition JSON from a public GitHub repository.

Branch selection is automatic:
- dev -> Dev
- sit -> SIT
- uat -> UAT
- prod -> master

## Usage

```hcl
module "dynamodb_table" {
  source = "tfr:///terraform-aws-modules/dynamodb-table/aws//wrappers/enforced2"

  environment            = "dev"
  kms_key_arn            = "arn:aws:kms:us-east-1:123456789012:key/abcd-1234"
  table_definition_repo  = "my-org/my-table-definitions"
  table_definition_path  = "dynamodb/app-table.json"

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

- The JSON is fetched from `https://raw.githubusercontent.com/<repo>/<branch>/<path>` based on the environment mapping above.
- When the table definition is loaded, `hash_key`, `range_key`, `attributes`, `global_secondary_indexes`, `local_secondary_indexes`, and TTL settings come from the JSON. Values in `table` override the JSON if both are set.
- Import table and global table witness are disabled. These features will be explored in future based on requirements.
