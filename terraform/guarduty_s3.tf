module "guardduty_antimalware" {
  source = "/home/jiin995/work/terraform-modules/terraform-aws-guardduty-malware-protection-for-s3"

  name_prefix = var.resource_name_prefix

  destination_bucket_arn = aws_s3_bucket.clean_bucket.arn
}