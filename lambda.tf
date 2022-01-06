data "template_file" "handler" {
  template = templatefile("${path.module}/templates/basic-auth.js", {
    username = var.basic_auth_username,
    password = var.basic_auth_password,
  })
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "${path.module}/lambdas/basic-auth.zip"

  source {
    content  = data.template_file.handler.rendered
    filename = "basic-auth.js"
  }
}

resource "aws_lambda_function" "basic_auth" {
  count            = var.basic_auth_enabled ? 1 : 0
  provider         = "aws.virginia"
  filename         = "${path.module}/lambdas/basic-auth.zip"
  function_name    = "${var.prefix}-basic-auth"
  role             = aws_iam_role.lambda.0.arn
  handler          = "basic-auth.handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "nodejs12.x"
  memory_size      = 128
  publish          = true
}
