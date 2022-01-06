resource "aws_route53_record" "main" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect" {
  count   = var.redirect_domain_name != "null" ? 1 : 0
  zone_id = var.zone_id
  name    = var.redirect_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.redirect.0.domain_name
    zone_id                = aws_cloudfront_distribution.redirect.0.hosted_zone_id
    evaluate_target_health = false
  }
}
