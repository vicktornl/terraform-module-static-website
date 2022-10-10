data "template_file" "handler_basic_auth" {
  template = templatefile("${path.module}/templates/basic-auth.js", {
    username = var.basic_auth_username,
    password = var.basic_auth_password,
  })
}

data "template_file" "handler_index" {
  template = templatefile("${path.module}/templates/indexh.js", {})
}

data "archive_file" "lambda_basic_auth" {
  type        = "zip"
  output_path = "${path.module}/lambdas/basic-auth.zip"

  source {
    content  = data.template_file.handler_basic_auth.rendered
    filename = "basic-auth.js"
  }
}

data "archive_file" "lambda_index" {
  type        = "zip"
  output_path = "${path.module}/lambdas/index.zip"

  source {
    content  = data.template_file.handler_index.rendered
    filename = "index.js"
  }
}

resource "aws_lambda_function" "basic_auth" {
  count            = var.basic_auth_enabled ? 1 : 0
  provider         = "aws.virginia"
  filename         = "${path.module}/lambdas/basic-auth.zip"
  function_name    = "${var.prefix}-basic-auth"
  role             = aws_iam_role.lambda.0.arn
  handler          = "basic-auth.handler"
  source_code_hash = data.archive_file.lambda_basic_auth.output_base64sha256
  runtime          = "nodejs12.x"
  memory_size      = 128
  publish          = true
}

resource "aws_lambda_function" "index" {
  provider         = "aws.virginia"
  filename         = "${path.module}/lambdas/index.zip"
  function_name    = "${var.prefix}-index"
  role             = aws_iam_role.lambda.0.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_index.output_base64sha256
  runtime          = "nodejs12.x"
  memory_size      = 128
  publish          = true
}
