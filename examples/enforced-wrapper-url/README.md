# Enforced wrapper with public URL table definition

This example uses a single `main.tf` and environment-specific tfvars files.
The table definition JSON is fetched from a public GitHub repo.

## Run

```bash
terraform init
terraform apply -var-file=dev/terraform.tfvars
```

```bash
terraform apply -var-file=sit/terraform.tfvars
```

```bash
terraform apply -var-file=uat/terraform.tfvars
```

```bash
terraform apply -var-file=prod/terraform.tfvars
```
