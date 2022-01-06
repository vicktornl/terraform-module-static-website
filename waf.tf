resource "aws_waf_web_acl" "main" {
  count       = var.waf_enabled ? 1 : 0
  name        = var.prefix
  metric_name = replace(var.prefix, "-", "")

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = var.waf_rule_id
    type     = "REGULAR"
  }
}
