provider "aws" {
  region = "us-west-1"
}

# Create a new VPC
resource "aws_vpc" "test_vpc" {  # EDIT : Replace test_vpc with custom name. 
  cidr_block = "15.0.0.0/16" # EDIT : Update range to avoid conflict. Can increment 15.x.x.x
  tags = {
    Name = "test_vpc"
  }
}

# Create two public subnets in different AZs
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "15.0.1.0/24" # EDIT : Update range to avoid conflict. Can increment 15.x.x.x
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "15.0.2.0/24" # EDIT : Update range to avoid conflict. Can increment 15.x.x.x
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "test_igw" # EDIT : Replace test_igw with custom internet gateway name. 
  }
}

# Create a public route table and associate it with the subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "subnet1_assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet2_assoc" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for the ALB to allow HTTP/HTTPS inbound traffic
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

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

  tags = {
    Name = "alb_sg"
  }
}

# Security Group for the EC2 instances: only allow traffic from the ALB
resource "aws_security_group" "instance_sg" { # EDIT : Change instance_sg name each time.
  name        = "instance_sg"
  description = "Allow inbound traffic from the ALB"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance_sg"
  }
}

# Create the Application Load Balancer (ALB)
resource "aws_lb" "test_alb" { # EDIT : Change test_alb name each time.
  name               = "test-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  security_groups    = [aws_security_group.alb_sg.id]
  tags = {
    Name = "test_alb"
  }
}

# Create a Target Group for the ALB
resource "aws_lb_target_group" "test_tg" { # Change test_tg with custom name for ALB.
  name     = "test-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "test_tg"
  }
}

# Create a Listener for the ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_tg.arn
  }
}

# Launch two EC2 instances with an existing key pair
resource "aws_instance" "test_instance1" { # EDIT : Change test_instance1 with custom resource name each time.
  ami                    = "ami-07d2649d67dbe8900"  # EDIT : Update with latest Ubuntu AMI in your region.
  instance_type          = "t2.micro"
  key_name               = "wordpress-test" # EDIT : Update with the existing EC2 key pair name.
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = file("install_wordpress.sh")

  tags = {
    Name = "TestInstance1" # EDIT : Change TestInstance1 label with custom name each time.
  }
}

resource "aws_instance" "test_instance2" { # EDIT : Change test_instance2 with custom resource name each time.
  ami                    = "ami-07d2649d67dbe8900" # EDIT : Update with latest Ubuntu AMI in your region.
  instance_type          = "t2.micro"
  key_name               = "wordpress-test" # EDIT : Update with the existing EC2 key pair name.
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  user_data = file("install_wordpress.sh")

  tags = {
    Name = "TestInstance2" # EDIT : Change TestInstance2 label with custom name each time.
  }
}

# Register the instances with the ALB Target Group
resource "aws_lb_target_group_attachment" "instance1_attachment" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id        = aws_instance.test_instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance2_attachment" {
  target_group_arn = aws_lb_target_group.test_tg.arn
  target_id        = aws_instance.test_instance2.id
  port             = 80
}
