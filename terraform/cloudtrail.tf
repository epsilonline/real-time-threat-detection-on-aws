######################################
# Cloutrail logs to S3
######################################

resource "aws_cloudtrail" "example" {
  depends_on = [aws_s3_bucket_policy.allow_trail_access]

  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.wazuh.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}
