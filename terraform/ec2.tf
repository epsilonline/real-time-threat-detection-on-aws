######################################
# MISCELLANEOUS RESOURCES
######################################

resource "aws_key_pair" "main" {
  key_name   = "${var.resource_name_prefix}-key"
  public_key = file("${path.module}/key.pub")

  tags = {
    Name = "${var.resource_name_prefix}-key"
  }
}
