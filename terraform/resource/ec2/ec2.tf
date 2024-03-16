module "ec2_instance_player" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  name = "${local.prefix}-player"

  instance_type               = "c6i.large"
  ami                         = "ami-0d92a4724cae6f07b"
  key_name                    = "devio-stg-key-pair"
  monitoring                  = false
  vpc_security_group_ids      = ["sg-00a8bbca60de63df1"]
  subnet_id                   = local.public_subnet_id_1a
  associate_public_ip_address = true
  ebs_optimized               = true
  enable_volume_tags          = true
}

