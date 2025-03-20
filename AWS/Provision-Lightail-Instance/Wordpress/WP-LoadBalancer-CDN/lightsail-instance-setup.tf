# Create two Lightsail instances running WordPress using a count
resource "aws_lightsail_instance" "wordpress" {
  count             = 2
  name              = "wordpress-instance-${count.index + 1}"
  availability_zone = "us-west-1a"       # Ensure this zone is valid for your region
  blueprint_id      = "wordpress"        # Preconfigured WordPress blueprint
  bundle_id         = "micro_1_0"        # Instance plan (adjust as needed)

  tags = {
    Environment = "production"
    Application = "WordPress"
  }
}