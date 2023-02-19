data "aws_caller_identity" "current_account" {}
data "aws_region" "current_region" {}

resource "aws_lambda_function" "eve_ai_lambda" {
  filename         = "${path.root}/../eve_ai.zip"
  function_name    = "eve-ai-lambda-${var.env}"
  role             = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/eve-ai-lambda-role"
  handler          = "lambda_code.eve_ai.lambda_handler"
  timeout          = 900
  memory_size      = 512
  source_code_hash = filebase64sha256("${path.root}/../eve_ai.zip")
  runtime = "python3.9"
  layers  = [aws_lambda_layer_version.python_packages_layer.arn]
}

resource "aws_lambda_layer_version" "python_packages_layer" {
  layer_name               = "eve_ai_lambda_layer"
  compatible_runtimes      = ["python3.9"]
  compatible_architectures = ["x86_64"]
  filename                 = "${path.root}/../lambda_layers.zip"
  source_code_hash         = filebase64sha256("${path.root}/../lambda_layers.zip")
}