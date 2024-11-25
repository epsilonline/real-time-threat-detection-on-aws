######################################
# Instance Profile
######################################

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${var.resource_name_prefix}-paloalto-ec2-ssm"
  role = aws_iam_role.iam_ec2_role.name
}

resource "aws_iam_role" "iam_ec2_role" {
  name        = "${var.resource_name_prefix}-paloalto-ec2-ssm"
  description = "The role for the developer resources EC2"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "ec2.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }
  })
}

resource "aws_iam_role_policy_attachment" "iam_policy_ec2_ssm_policy" {
  role       = aws_iam_role.iam_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

######################################
# Wazuh User
######################################

resource "aws_iam_user" "wazuh" {
  name = "${var.resource_name_prefix}-wazuh"
}

resource "aws_iam_policy" "wazuh_s3" {
  name = "${var.resource_name_prefix}-wazuh-s3"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "GetS3Logs",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject",
            "s3:ListBucket"
          ],
          "Resource" : [
            "${aws_s3_bucket.wazuh.arn}/*",
            aws_s3_bucket.wazuh.arn
          ]
        }
      ]
  })
}

resource "aws_iam_user_policy_attachment" "name" {
  user       = aws_iam_user.wazuh.name
  policy_arn = aws_iam_policy.wazuh_s3.arn
}

#