######################################
# Wazuh S3 bucket
######################################

resource "aws_s3_bucket" "wazuh_cloudtrail" {
  bucket = local.wazuh_bucket_name

  tags = {
    Name = "${var.resource_name_prefix}-${random_string.random.result}"
  }
}

moved {
  to   = aws_s3_bucket.wazuh_cloudtrail
  from = aws_s3_bucket.wazuh
}

data "aws_iam_policy_document" "allow_trail_access" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.wazuh_cloudtrail.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${local.trail_name}"]
    }
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.wazuh_cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${local.trail_name}"]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_trail_access" {
  bucket = aws_s3_bucket.wazuh_cloudtrail.id
  policy = data.aws_iam_policy_document.allow_trail_access.json
}

######################################
# GWLBTUN script bucket
######################################

resource "aws_s3_bucket" "gwlbtun" {
  bucket = local.gwlbtun_bucket_name

  tags = {
    Name = "${var.resource_name_prefix}-${random_string.random.result}"
  }
}

resource "aws_s3_object" "gwlbtub_scripts" {
  for_each = fileset(local.gwlbtub_scripts_path, "*.sh")
  bucket   = aws_s3_bucket.gwlbtun.id
  key      = each.value
  source   = "${local.gwlbtub_scripts_path}/${each.value}"

  etag = filemd5("${local.gwlbtub_scripts_path}/${each.value}")
}

######################################
# Destination bucket
######################################

resource "aws_s3_bucket" "clean_bucket" {
  bucket = local.clean_bucket_name

  tags = {
    Name = local.clean_bucket_name
  }
}

######################################
# Destination bucket
######################################

resource "aws_s3_bucket" "staging_bucketav" {
  bucket = local.staging_bucketav_bucket_name

  tags = {
    Name = local.clean_bucket_name
  }
}
