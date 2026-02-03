# Wrapper3 example (registry module source)

This example uses a single `main.tf` and environment-specific tfvars files.

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
