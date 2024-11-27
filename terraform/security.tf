######################################
# Enable Security Hub
######################################
resource "aws_securityhub_account" "account" {}

######################################
# Guard Duty
######################################

resource "aws_guardduty_detector" "this" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }

    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }
}

# resource "aws_guardduty_malware_protection_plan" "example" {
#   role = aws_iam_role.example.arn

#   protected_resource {
#     s3_bucket {
#       bucket_name     = aws_s3_bucket.example.id
#       object_prefixes = ["example1", "example2"]
#     }
#   }

#   actions {
#     tagging {
#       status = "ENABLED"
#     }
#   }

#   tags = {
#     "Name" = "example"
#   }
# }

######################################
# AWS Inspector
######################################

resource "aws_inspector2_enabler" "this" {
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
}