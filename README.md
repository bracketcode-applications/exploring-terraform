# Terraform Demo
General example of Infrastructure as Cloud (IaC) using Terraform.

## Cloud Provider

### AWS
To use Terraform with AWS you will need to utilize an assigned IAM Access Key with the appropriate permissions to provsion on AWS.

1. Log into AWS, Navigate to IAM and generate an Access Key for your user.
2. On your local computer open a terminal.
3. Set the AWS_ACCESS_KEY_ID environment variable.
  ```
  $ export AWS_ACCESS_KEY_ID=
  ```
4. Then set your secret key.
  ```
  $ export AWS_SECRET_ACCESS_KEY=
  ```

