################ CLOUDTRAIL ##################
resource "aws_cloudtrail" "cloudtrail_autotag" {
  name                       = "autotag-trail"
  s3_bucket_name             = aws_s3_bucket.cloudtrail_bucket[count.index].id
  enable_log_file_validation = true
  count                      = var.create_trail ? 1 : 0
}

############ CLOUDTRAIL S3 BUCKET ############
resource "random_pet" "cloudtrail_bucket_name" {
  prefix = "cloudtrail-autotag"
  count  = var.create_trail ? 1 : 0
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = random_pet.cloudtrail_bucket_name[count.index].id
  force_destroy = true
  count         = var.create_trail ? 1 : 0
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket[count.index].id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy_doc[count.index].json
  count  = var.create_trail ? 1 : 0
}

