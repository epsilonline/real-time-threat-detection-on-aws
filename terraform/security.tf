# Enable security hub
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


######################################
# AWS Inspector
######################################

resource "aws_inspector2_enabler" "this" {
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
}