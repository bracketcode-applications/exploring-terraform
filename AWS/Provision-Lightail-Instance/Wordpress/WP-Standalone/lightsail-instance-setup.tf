# Create a Lightsail instance running WordPress

resource "aws_lightsail_instance" "wordpress" {
  name              = "wordpress-instance"
  availability_zone = "us-west-2a"       # Ensure this zone is valid for your region
  blueprint_id      = "wordpress"        # Preconfigured WordPress blueprint
  bundle_id         = "micro_1_0"        # Instance plan (adjust as needed)
  
  # Optional: add tags for easier management
  tags = {
    Environment = "production"
    Application = "WordPress"
  }
}
