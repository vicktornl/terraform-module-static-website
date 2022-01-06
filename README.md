# Terraform module static website

```
module "examplecom" {
  source               = "git@github.com:vicktornl/terraform-module-static-website.git"
  zone_id              = aws_route53_zone.main.zone_id
  domain_name          = "example.com"
  redirect_domain_name = "www.example.com"
  acm_certificate_arn  = aws_acm_certificate.main.arn
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ARN of the ACM Certificate used for the CloudFront distributions (us-east-1) | `string` | n/a | yes |
| <a name="input_basic_auth_enabled"></a> [basic\_auth\_enabled](#input\_basic\_auth\_enabled) | Controls wether basic auth is enabled | `bool` | `false` | no |
| <a name="input_basic_auth_password"></a> [basic\_auth\_password](#input\_basic\_auth\_password) | Basic auth password | `string` | `"auth"` | no |
| <a name="input_basic_auth_username"></a> [basic\_auth\_username](#input\_basic\_auth\_username) | Basic auth username | `string` | `"basic"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Fully qualified domain name | `string` | n/a | yes |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | n/a | `string` | `"error.html"` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | n/a | `string` | `"index.html"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix used for all resource names | `string` | n/a | yes |
| <a name="input_redirect_domain_name"></a> [redirect\_domain\_name](#input\_redirect\_domain\_name) | Optional fully qualified domain name to redirect from | `string` | `"null"` | no |
| <a name="input_waf_enabled"></a> [waf\_enabled](#input\_waf\_enabled) | Controls wether WAF is enabled for the CloudFront distributions | `bool` | `false` | no |
| <a name="input_waf_rule_id"></a> [waf\_rule\_id](#input\_waf\_rule\_id) | WAF Rule id | `string` | `""` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Hosted zone id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | n/a |
<!-- END_TF_DOCS -->
