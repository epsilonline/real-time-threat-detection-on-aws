module "guardduty_antimalware" {
  source  = "epsilonline/guardduty-malware-protection-for-s3/aws"
  version = "0.0.1"

  name_prefix = var.resource_name_prefix

  destination_bucket_arn = aws_s3_bucket.clean_bucket.arn
}