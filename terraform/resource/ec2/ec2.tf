# -----------------
# EC2
# -----------------
# player instance
module "ec2_instance_player" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name = "${local.prefix}-player"

  instance_type               = "c7a.medium"
  ami                         = "ami-0937f4bab7bea4382" # initial:  ami-0937f4bab7bea4382 , latest: ami-0600bc81342bb674c
  key_name                    = "iscon_2024_key"
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.sg_player.id]
  subnet_id                   = local.public_subnet_id_1a
  associate_public_ip_address = true
  ebs_optimized               = true
  enable_volume_tags          = true
}

# benchmaker instance
# module "ec2_instance_benchmaker" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.6.0"

#   name = "${local.prefix}-player"

#   instance_type               = "c7a.medium"
#   ami                         = "ami-015450874c83c16e5"
#   key_name                    = "iscon_2024_key"
#   monitoring                  = false
#   vpc_security_group_ids      = [aws_security_group.sg_player.id]
#   subnet_id                   = local.public_subnet_id_1a
#   associate_public_ip_address = true
#   ebs_optimized               = true
#   enable_volume_tags          = true
# }

