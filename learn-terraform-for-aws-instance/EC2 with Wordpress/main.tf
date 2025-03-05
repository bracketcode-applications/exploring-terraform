provider "aws" {
  region = "us-west-1"
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_test_sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "wordpress" {
  ami             = "ami-07d2649d67dbe8900" # Update with latest Ubuntu AMI
  instance_type   = "t2.micro"
  key_name        = "wordpress-test"
  security_groups = [aws_security_group.wordpress_sg.name]

  user_data = file("install_wordpress.sh")

  tags = {
    Name = "WordPressInstance-Test"
  }
}
