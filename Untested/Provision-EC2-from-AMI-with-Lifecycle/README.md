# Create EC2 AMI with Lifecycle

The sample Terraform code will automate the process of creating an AMI from an existing EC2 instance every 24 hours and attaches a Lifecycle policy that retains the created AMIs for 7 days before before automatic deletion.

## Running the Code

1.	Initialize Terraform:
```
terraform init
```
2. 	Plan the Execution:
```
terraform plan
```
3.	Apply the Configuration:
```
terraform apply -auto-approve
```
