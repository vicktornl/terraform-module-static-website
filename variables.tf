variable "prefix" {
  type        = string
  description = "Prefix used for all resource names"
}

variable "zone_id" {
  type        = string
  description = "Hosted zone id"
}

variable "domain_name" {
  type        = string
  description = "Fully qualified domain name"
}

variable "redirect_domain_name" {
  type        = string
  default     = "null"
  description = "Optional fully qualified domain name to redirect from"
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM Certificate used for the CloudFront distributions (us-east-1)"
}

variable "waf_enabled" {
  type        = bool
  default     = false
  description = "Controls wether WAF is enabled for the CloudFront distributions"
}

variable "waf_rule_id" {
  type        = string
  default     = ""
  description = "WAF Rule id"
}

variable "basic_auth_enabled" {
  type        = bool
  default     = false
  description = "Controls wether basic auth is enabled"
}

variable "basic_auth_username" {
  type        = string
  default     = "basic"
  description = "Basic auth username"
}

variable "basic_auth_password" {
  type        = string
  default     = "auth"
  description = "Basic auth password"
}

variable "cache_enabled" {
  type        = bool
  default     = false
  description = "Controls wether caching is enabled"
}

variable "rewrite_uri" {
  type        = string
  default     = ""
  description = "Rewrite all trafic to this absolute uri (commonly used for React websites with History pushState routing)"
}