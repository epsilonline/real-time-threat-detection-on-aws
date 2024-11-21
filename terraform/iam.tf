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