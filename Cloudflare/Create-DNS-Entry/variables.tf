variable "cloudflare_api_token" {
  description = "api-token-goes-here" # API token should have permissions to manage DNS
  type        = string
}

variable "domain_name" {
  description = "placeholder.com"
  type        = string
}

variable "record_name" {
  description = "The subdomain or record name to create (e.g., www, api)."
  type        = string
}

variable "record_type" {
  description = "The DNS record type (e.g., A, CNAME)."
  type        = string
  default     = "A"
}

variable "record_value" {
  description = "The value for the DNS record (IP address for A records, domain for CNAME)."
  type        = string
}

variable "record_ttl" {
  description = "Time-to-live for the DNS record in seconds."
  type        = number
  default     = 3600
}

variable "record_proxied" {
  description = "Whether to use Cloudflare proxy for this record (true/false)."
  type        = bool
  default     = false
}
