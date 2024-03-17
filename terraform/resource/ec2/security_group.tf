# --------------------
# HTTP 
# --------------------
# 自分のIPアドレスを指定するときに使用
# data "http" "ifconfig" {
#   url = "https://ifconfig.co/ip"
# }
data "http" "ipv4_icanhazip" {
  url = "http://ipv4.icanhazip.com/"
}

# IP --------------------------
#自分のIPアドレスを使用するときに使用
variable "allowed_cidr" {
  default = null
}

locals {
  current_ip   = chomp(data.http.ipv4_icanhazip.response_body)
  allowed_cidr = (var.allowed_cidr == null) ? "${local.current_ip}/32" : var.allowed_cidr
}
# -----------------------------


# ----------------------
# Security group
# ----------------------
# player security group
resource "aws_security_group" "sg_player" {
  name        = "player"
  description = "Security group for player"
  vpc_id      = local.vpc_id
  tags = {
    Name = "${local.prefix}-sg-player"
  }
}

resource "aws_security_group_rule" "player_out" {
  security_group_id = aws_security_group.sg_player.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic by default"
}

resource "aws_security_group_rule" "player_in_http" {
  security_group_id = aws_security_group.sg_player.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = [local.allowed_cidr]
  description       = "from my IP"
}

resource "aws_security_group_rule" "player_in_ssh" {
  security_group_id = aws_security_group.sg_player.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = [local.allowed_cidr]
  description       = "from my IP"
}

