# Launch A Wordpress Lightsail Instance
Use Hashicorp's [Terraform](https://developer.hashicorp.com/terraform) to launch a Worpress Lightsail intance.

Below is a list of the known available regions for Lightsail. When modifying region make sure to refer to this list. You can also refer to the [AWS offical page](https://docs.aws.amazon.com/lightsail/latest/userguide/understanding-regions-and-availability-zones-in-amazon-lightsail.html).

| Location | Region |
| -------- | ------- |
| US East (Ohio) | us-east-2 |
| US East (N. Virginia)  | us-east-1 |
| US West (Oregon) | us-west-2 |
| Asia Pacific (Mumbai) | ap-south-1 |
| Asia Pacific (Seoul) | ap-northeast-2 |
| Asia Pacific (Singapore) | ap-southeast-1 |
| Asia Pacific (Sydney) | ap-southeast-2 |
| Asia Pacific (Tokyo) | ap-northeast-1 |
| Canada (Central) | ca-central-1 |
| EU (Frankfurt) | eu-central-1 |
| EU (Ireland) | eu-west-1 |
| EU (London) | eu-west-2 |
| EU (Paris) | eu-west-3 |
| EU (Stockholm) | eu-north-1 |

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

