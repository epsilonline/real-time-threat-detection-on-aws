######################################
# Cloutrail logs to S3
######################################

resource "aws_cloudtrail" "trail" {
  depends_on = [aws_s3_bucket_policy.allow_trail_access]

  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.wazuh_cloudtrail.id
  include_global_service_events = false
}
