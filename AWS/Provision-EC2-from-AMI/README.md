# Launch an EC2 Instance from an AMI.
Use Hashicorp's [Terraform](https://developer.hashicorp.com/terraform) to launch a Worpress Lightsail intance.

## Commands
Run the following commands from your working directory (folder).

Initiate
```
terraform init
```

Format Confirguration
```
terraform fmt
```

Validate Configuration
```
terraform validate
```
Apply (aka launch) Configuration
```
terraform apply
```
You can make use of the `-auto-approve` option to instruct Terraform to apply without asking for confirmation.
```
terraform apply -auto-approve
```

Show Configuration
```
terraform show
```

Destroy
```
terraform destroy
```

