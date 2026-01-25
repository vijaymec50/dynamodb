# Enforced wrapper example

This example uses a single `main.tf` with per-environment variable files and a JSON table definition.

Note: `on_demand_throughput` is required for non-prod, and for prod when using `billing_mode = "PAY_PER_REQUEST"`.

## Run (non-prod)

```bash
terraform init
terraform apply -var-file=non-prod/terraform.tfvars
```

## Table definition JSON

Update `table-definition.json` with the keys, attributes, and GSI definitions provided by developers.
For provisioned + autoscaling examples, use `table-definition-provisioned.json` so GSIs include read/write capacities.

## Run (prod)

```bash
terraform init
terraform apply -var-file=prod/terraform.tfvars
```

## Run (prod, provisioned + autoscaling)

```bash
terraform init
terraform apply -var-file=prod/terraform.autoscaling.tfvars
```
