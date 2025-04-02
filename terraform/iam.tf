resource "aws_iam_role" "iam_ec2_role" {
  name        = "${var.resource_name_prefix}-ec2-ssm"
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


resource "aws_iam_instance_profile" "iam_ec2_role" {
  name = aws_iam_role.iam_ec2_role.name
  role = aws_iam_role.iam_ec2_role.name
}

######################################
# EC2 Wazuh Role
######################################

resource "aws_iam_role" "ec2_wazuh" {
  name = "${var.resource_name_prefix}-ec2-wazuh"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_instance_profile" "ec2_wazuh" {
  name = aws_iam_role.ec2_wazuh.name
  role = aws_iam_role.ec2_wazuh.name
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
            "${aws_s3_bucket.wazuh_cloudtrail.arn}/*",
            aws_s3_bucket.wazuh_cloudtrail.arn
          ]
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "wazuh_s3" {
  role       = aws_iam_role.ec2_wazuh.name
  policy_arn = aws_iam_policy.wazuh_s3.arn
}

resource "aws_iam_role_policy_attachment" "iam_policy_wazuh_ec2_ssm_policy" {
  role       = aws_iam_role.ec2_wazuh.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

######################################
# EC2 GWLBTUB Role
######################################

resource "aws_iam_role" "ec2_gwlbtun" {
  name = "${var.resource_name_prefix}-ec2-gwlbtun"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_instance_profile" "ec2_gwlbtun" {
  name = aws_iam_role.ec2_gwlbtun.name
  role = aws_iam_role.ec2_gwlbtun.name
}

resource "aws_iam_policy" "gwlbtub_s3" {
  name = "${var.resource_name_prefix}-gwlbtun-s3"

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
            "${aws_s3_bucket.gwlbtun.arn}/*",
            aws_s3_bucket.gwlbtun.arn
          ]
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "gwlbtub_s3" {
  role       = aws_iam_role.ec2_gwlbtun.name
  policy_arn = aws_iam_policy.gwlbtub_s3.arn
}

resource "aws_iam_role_policy_attachment" "iam_policy_gwlbtub_ec2_ssm_policy" {
  role       = aws_iam_role.ec2_gwlbtun.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy_attachment" "ids_wazuh_s3" {
  role       = aws_iam_role.ec2_gwlbtun.name
  policy_arn = aws_iam_policy.wazuh_s3.arn
}

#######################################
#
######################################
resource "aws_iam_user" "wazuh_user" {
  name = "${var.resource_name_prefix}-wazuh-user"
}

resource "aws_iam_user_policy_attachment" "wazuh_user_ReadOnly" {
  user       = aws_iam_user.wazuh_user.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}