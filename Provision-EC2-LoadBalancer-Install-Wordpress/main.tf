# Provider
provider "aws" {
  region = var.region
}

variable "region" {
  default = "us-west-1"
}

variable "ami" {
  description = "AMI ID for Ubuntu"
  # Replace with a valid AMI ID for your region.
  default     = "ami-07d2649d67dbe8900"
}

variable "instance_type" {
  # If needed, replace with alternate tiers. 
  default = "t2.micro"
}

# Use the default VPC. Can be altered to use other existing vpc.
data "aws_vpc" "default" {
  default = true
}

# Get available subnets in the default VPC (assumes at least two for high availability)
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Security Group for EC2 instances and the load balancer. Can change name (wordpress_sg) if needed.
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Provision two EC2 instances with a user_data script to install WordPress.
resource "aws_instance" "wordpress" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  # For distribution across subnets, use the count index to pick a subnet.
  subnet_id     = element(data.aws_subnet_ids.default.ids, count.index)
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  # User data installs Apache, PHP, downloads & unpacks WordPress
  #user_data = <<-EOF
              #!/bin/bash
              #apt-get update -y
              #apt-get install -y apache2 php php-mysql wget unzip
              #systemctl start apache2
              # Download and unpack WordPress
              #cd /tmp
              #wget https://wordpress.org/latest.zip
              #unzip latest.zip
              #cp -r wordpress/* /var/www/html/
              #chown -R www-data:www-data /var/www/html/
              #EOF
  user_data = file("install_wordpress.sh")

  tags = {
    Name = "wordpress-instance-${count.index}"
  }
}

# Create an Application Load Balancer (ALB) for the two instances.
resource "aws_lb" "wordpress_load_balancer" {
  name               = "wordpress-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wordpress_sg.id]
  subnets            = data.aws_subnet_ids.default.ids

  tags = {
    Name = "wordpress-load-balancer"
  }
}

# Create a target group for HTTP on port 80. 
resource "aws_lb_target_group" "wordpress_tg" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200-299"
  }
}

# Create a listener for the ALB on port 80
resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

# Register each EC2 instance with the target group. Notice target_id is referencing ID set in line 63.
resource "aws_lb_target_group_attachment" "wordpress_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.wordpress_tg.arn
  target_id        = aws_instance.wordpress[count.index].id
  port             = 80
}

# (Optional) Output the DNS name of the load balancer.
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.wordpress_alb.dns_name
}
