# Provision EC2 with Wordpress
This is a sample using [Terraform](https://developer.hashicorp.com/terraform) to launch two EC2 instances with Wordpress preinstalled and then adding them to an ECS Load Balancer.

## Run Commands
Run the following commands from your working directory (folder).

Initiate
```
terraform init
```

Format Confirguration (Optional)
```
terraform fmt
```

Validate Configuration
```
terraform validate
```
Apply (aka launch) Configuration
```
terraform apply -auto-approve
```

Show Configuration (Optional)
```
terraform show
```

After launch navigate to...
```
http://your-domain/wp-admin/install.php
```
...and complete the set up process.

To terminate the EC2 and associated security group use the destroy command.
```
terraform destroy
```
