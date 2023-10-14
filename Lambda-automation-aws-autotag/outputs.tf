# Output value definitions

output "lambda_bucket" {
  description = "Lambda bucket to store code"
  value       = aws_s3_bucket.lambda_bucket.id
}
