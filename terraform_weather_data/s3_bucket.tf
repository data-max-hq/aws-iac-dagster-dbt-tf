resource "aws_s3_bucket" "weather-data-bucket" {
  bucket = local.bucket_name
}