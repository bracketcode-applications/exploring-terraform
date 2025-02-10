provider "aws" {
  region = "us-east-1"
}

# Fetch the instance details
data "aws_instance" "example" {
  instance_id = "i-0abcdef1234567890"  # Replace with your EC2 instance ID
}

# Create the AMI from an existing EC2 instance
resource "aws_ami_from_instance" "example_ami" {
  name               = "my-custom-ami"
  source_instance_id = data.aws_instance.example.id
  description        = "An AMI created using Terraform"

  tags = {
    Name = "my-custom-ami"
  }
}

# IAM Role for Lifecycle Policy
resource "aws_iam_role" "dlm_role" {
  name = "dlm-lifecycle-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "dlm.amazonaws.com"
      }
    }]
  })
}

# Attach IAM Policy for DLM
resource "aws_iam_role_policy_attachment" "dlm_policy" {
  role       = aws_iam_role.dlm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataLifecycleManagerServiceRole"
}

# Lifecycle Policy to Manage AMIs
resource "aws_dlm_lifecycle_policy" "ami_policy" {
  description        = "Lifecycle policy to manage AMIs"
  execution_role_arn = aws_iam_role.dlm_role.arn
  state             = "ENABLED"

  policy_details {
    resource_types = ["INSTANCE"]
    
    schedule {
      name = "Daily AMI Backup"

      create_rule {
        interval      = 24   # Every 24 hours
        interval_unit = "HOURS"
      }

      retain_rule {
        count = 7  # Retain AMIs for 7 days
      }

      tags_to_add = {
        Backup = "true"
      }
    }
  }
}

output "ami_id" {
  value = aws_ami_from_instance.example_ami.id
}