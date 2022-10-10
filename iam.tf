data "aws_iam_policy_document" "lambda_assume_role" {
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

resource "aws_iam_role" "lambda_basic_auth" {
  name               = "${var.prefix}-lambda-basic-auth"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role" "lambda_index" {
  name               = "${var.prefix}-lambda-index"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
