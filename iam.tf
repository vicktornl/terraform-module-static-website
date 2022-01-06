data "aws_iam_policy_document" "lambda_assume_role" {
  count = var.basic_auth_enabled ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  count              = var.basic_auth_enabled ? 1 : 0
  name               = "${var.prefix}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.0.json
}
