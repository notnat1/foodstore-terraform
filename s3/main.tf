provider "aws" {
  region = "ap-southeast-3"
}

resource "random_pet" "bucket_name" {
  length = 2
}

resource "aws_s3_bucket" "jenkins-magang-foodstore-bucket-tf" {
  bucket = "foodstore-bucket-tf-${random_pet.bucket_name.id}"
  # acl    = "private"

  tags = {
    Name        = "foodstore-bucket-tf-${random_pet.bucket_name.id}"
    Environment = "Test"
    Service     = "create-by-terraform"
  }
}

resource "aws_s3_bucket_acl" "s3-acl-tf" {
  bucket = aws_s3_bucket.jenkins-magang-foodstore-bucket-tf.id
  acl    = "private"
}






































# resource "aws_s3_bucket_versioning" "versioning_example" {
#   bucket = aws_s3_bucket.jenkins-magang-foodstore-bucket-tf.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "default_encryption" {
#   bucket = aws_s3_bucket.jenkins-magang-foodstore-bucket-tf.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# output "s3_bucket_name" {
#   description = "The name of the S3 bucket"
#   value       = aws_s3_bucket.jenkins-magang-foodstore-bucket-tf.bucket
# }