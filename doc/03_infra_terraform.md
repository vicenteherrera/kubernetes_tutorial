

## Deploy infrastructure with Terraform

Change to the `infra` directory and initialize Terraform's Azure driver:

```
$ terraform init
```

Test the execution plan:

```
$ terraform plan -var client_id=$ARM_CLIENT_ID -var client_secret=$ARM_CLIENT_SECRET
```

Run the execution plan using credetials for the service principal:

```
$ terraform apply -var client_id=$ARM_CLIENT_ID -var client_secret=$ARM_CLIENT_SECRET
```
