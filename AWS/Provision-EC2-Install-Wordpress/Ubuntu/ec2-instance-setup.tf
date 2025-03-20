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