/* 
Configuration of S3 bucket for certs and replay
storage. Uses server side encryption to secure
session replays and SSL certificates.
*/

// S3 bucket for cluster storage
resource "aws_s3_bucket" "storage" {
  bucket        = var.s3_bucket_name
  # acl           = "private"
  force_destroy = true
}
resource "aws_s3_bucket_server_side_encryption_configuration" "storage" {
  bucket = aws_s3_bucket.storage.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}