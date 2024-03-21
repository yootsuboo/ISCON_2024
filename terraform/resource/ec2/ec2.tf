# -----------------
# EC2
# -----------------
# player instance
module "ec2_instance_player" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name = "${local.prefix}-player"

  instance_type               = "t3.large"
  ami                         = "ami-04db10797361332a8"
  key_name                    = "iscon_2024_key"
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.sg_player.id]
  subnet_id                   = local.public_subnet_id_1a
  associate_public_ip_address = true
  ebs_optimized               = true
  enable_volume_tags          = true
}

