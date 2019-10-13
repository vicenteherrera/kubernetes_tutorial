

## Deploy infrastructure with Terraform

Change to the `infra` directory and initialize Terraform's Azure driver:

You can edit the  `terraform.tfvars` to select a different availability zone, or name prefix for resources. But the prefix must contain only alphabetical characters, because it is used for the name of the Azure Container Registry, and that only allows this kind of characters (no numbers, dashes or undescores).

```
$ cd infra
$ terraform init
```

Test the execution plan:

```
$ terraform plan -out=plan.zip
```

We store the generated plan, so if once deployed we change the content of the Terraform files, we still know how to destroy what has been created.

Run the execution plan using credetials for the service principal:

```
$ terraform plan
```


