This folder contains environment-specific variable overrides for the `enforced-wrapper` example.

Sensitive values (for example, AWS ARNs and KMS keys) are not committed to the repository. To use this example:

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Fill in placeholder values (replace `ACCOUNT_ID`, `REGION`, and KMS key placeholder).
3. Run `terraform init` and `terraform apply -var-file=terraform.tfvars`.

Do not commit real secrets or credentials to the repository.