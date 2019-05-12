data "aws_ami_ids" "ubuntu" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "aws_sg" {
  name        = "vpn"
  description = "allow necessary traffic"

  #  ingress {
  #    from_port   = 1194
  #    to_port     = 1194
  #    protocol    = "udp"
  #    cidr_blocks = ["0.0.0.0/0"]
  #  }
  #
  #  egress {
  #    from_port   = 1194
  #    to_port     = 1194
  #    protocol    = "udp"
  #    cidr_blocks = ["0.0.0.0/0"]
  #  }
}

resource "aws_security_group_rule" "ingress_udp_ports" {
  type              = "ingress"
  count             = "${length(var.allowed_udp_ports)}"
  from_port         = "${element(var.allowed_udp_ports, count.index)}"
  to_port           = "${element(var.allowed_udp_ports, count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.aws_sg.id}"
}

resource "aws_security_group_rule" "egress_udp_ports" {
  type              = "egress"
  count             = "${length(var.allowed_udp_ports)}"
  from_port         = "${element(var.allowed_udp_ports, count.index)}"
  to_port           = "${element(var.allowed_udp_ports, count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.aws_sg.id}"
}

resource "aws_security_group_rule" "ingress_tcp_ports" {
  type              = "ingress"
  count             = "${length(var.allowed_tcp_ports)}"
  from_port         = "${element(var.allowed_tcp_ports, count.index)}"
  to_port           = "${element(var.allowed_tcp_ports, count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.aws_sg.id}"
}

resource "aws_security_group_rule" "egress_tcp_ports" {
  type              = "egress"
  count             = "${length(var.allowed_tcp_ports)}"
  from_port         = "${element(var.allowed_tcp_ports, count.index)}"
  to_port           = "${element(var.allowed_tcp_ports, count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.aws_sg.id}"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.aws_sg.id}"
}

resource "aws_instance" "vpn" {
  # count = "${length(var.hosts)}"
  ami                         = "${data.aws_ami_ids.ubuntu.ids[0]}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.sshpubkey.id}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.aws_sg.id}"]
}

#resource "aws_route53_record" "aws_vm_dns" {
#  count   = "${length(var.hosts)}"
#  zone_id = "${var.zone_id}"
#  name    = "${element(var.hosts, count.index)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.aws_vm.*.public_ip, count.index)}"]
#}
