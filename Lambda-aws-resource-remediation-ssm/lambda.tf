######################## LAMBDA S3 BUCKET FOR BOTH FUNCTIONS ########################
resource "random_pet" "lambda_bucket_prefix" {
  prefix = "lambda-code-storage"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_prefix.id
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_bkt_encryptn" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

//////////////////////////// LAMBDA EVALUATOR FUNCTION ////////////////////////////
resource "aws_lambda_function" "compliance_evaluator" {
  function_name    = var.lambda_evaluator_name
  role             = aws_iam_role.lambda_evaluator_role.arn
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_evaluator.key
  source_code_hash = data.archive_file.lambda_eval_compliance.output_base64sha256
  runtime          = "python3.9"
  handler          = "main_lambda.lambda_handler"
  timeout          = 300
  memory_size      = 128
  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}

######################## LAMBDA EVALUATOR LOG GROUP ########################
resource "aws_cloudwatch_log_group" "lambda_evaluator" {
  name              = "/aws/lambda/${var.lambda_evaluator_name}"
  retention_in_days = 30
}

##################### LAMBDA EVALUATOR DEPLOYMENT PACKAGE #####################
data "archive_file" "lambda_eval_compliance" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/src_eval"
  output_path = "${path.module}/lambda/lambda_evaluator.zip"
}

resource "aws_s3_object" "lambda_evaluator" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_evaluator.zip"
  source = data.archive_file.lambda_eval_compliance.output_path
  etag   = filemd5(data.archive_file.lambda_eval_compliance.output_path)
}

//////////////////////////// LAMBDA MAILER FUNCTION ////////////////////////////
resource "aws_lambda_function" "lambda_mailer" {
  function_name    = var.lambda_mailer_name
  role             = aws_iam_role.lambda_mailer_role.arn
  s3_bucket        = aws_s3_bucket.lambda_bucket.id
  s3_key           = aws_s3_object.lambda_mailer.key
  source_code_hash = data.archive_file.lambda_email_compliance.output_base64sha256
  runtime          = "python3.9"
  handler          = "main_lambda.lambda_handler"
  timeout          = 300
  memory_size      = 128
  environment {
    variables = {
      LOG_LEVEL      = "INFO"
      FALLBACK_EMAIL = var.sender_email_address
    }
  }
}

######################## LAMBDA MAILER LOG GROUP ########################
resource "aws_cloudwatch_log_group" "lambda_mailer" {
  name              = "/aws/lambda/${var.lambda_mailer_name}"
  retention_in_days = 30
}

##################### LAMBDA MAILER DEPLOYMENT PACKAGE #####################
data "archive_file" "lambda_email_compliance" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/src_mailer"
  output_path = "${path.module}/lambda/lambda_mailer.zip"
}

resource "aws_s3_object" "lambda_mailer" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_mailer.zip"
  source = data.archive_file.lambda_email_compliance.output_path
  etag   = filemd5(data.archive_file.lambda_email_compliance.output_path)
}
