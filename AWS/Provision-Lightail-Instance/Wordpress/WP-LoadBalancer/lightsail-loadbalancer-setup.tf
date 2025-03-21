# Create a Lightsail load balancer
resource "aws_lightsail_lb" "test" {
  name              = "wordpress-lb"
  health_check_path = "/"                # Define a health check endpoint; adjust as needed
  instance_port     = 80                 # Port on which the WordPress instances listen

  tags = {
    Environment = "production"
    Application = "WordPress"
  }
}

# Attach each Lightsail instance to the load balancer using count
resource "aws_lightsail_lb_attachment" "lb_attachment" {
  count = 2
  lb_name = aws_lightsail_lb.test.name
  instance_name      = aws_lightsail_instance.wordpress[count.index].name
}