# Terraform Demo
This a project to help users get an introduction to Hashicorp's [Terraform](https://developer.hashicorp.com/terraform) along with concepts related to infrastructure as code (IaC). Step by step instructions and guides will be provided through this project's README. We also recommend visitng the official guides provided by [Hashicorp](https://developer.hashicorp.com/terraform/docs). Many thanks to the contributors to this project. The end goal is to provide a useful resource for those interested in getting started with IaC. Feel free to download or fork from this project. If you wish to report issues or contribute directly to this particular project, please contact our team.

## Terraform Installation for Mac
Check if you have Homebrew installed by typing in terminal: <br />
```$ brew ```

If not found, install Homebrew.<br />
M-chip vs [Intel](https://brew.sh/) 

If running homebrew run command to update to latest version. <br />
```$ brew update ```

Install Terraform 
First install the HashiCorp tap, a repository of all our Homebrew packages. <br />
```$ brew tap hashicorp/tap ```

Install Terraform using the following command. <br />
```$ brew install hashicorp/tap/terraform```

Verify Terraform is running. <br />
```$ terraform -help```

## IaC by Cloud Provider

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

