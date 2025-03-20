terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  # Use an API token with permissions to manage DNS settings.
  api_token = var.cloudflare_api_token
}

# Look up the zone by your domain name
data "cloudflare_zones" "zone" {
  filter {
    name = var.domain_name
  }
}

# Create a DNS record within the zone
resource "cloudflare_record" "dns_record" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = var.record_name      # e.g., "www" or "api"
  type    = var.record_type      # e.g., "A", "CNAME", etc.
  value   = var.record_value     # e.g., the IP address or target hostname
  ttl     = var.record_ttl       # Time-to-live in seconds
  proxied = var.record_proxied   # true if you want Cloudflare to proxy the record
}
