#resource "aws_s3_bucket" "ec00-bucket" {
#  bucket         = "ec00-bucket"
#  acl            = "private"
#  region         = "eu-central-1"
#
#  versioning {
#    enabled = true
#  }
#
#  lifecycle {
#   prevent_destroy = true
#    prevent_destroy = false
#  }
#
#  tags = {
#    Name = "bucket for terraform state files"
#  }
#}

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
}

resource "aws_security_group_rule" "ingress_udp_ports" {
  type              = "ingress"
# Comment for test for_each in terraform 0.12.6
# count             = length(var.allowed_udp_ports)
# from_port         = element(var.allowed_udp_ports, count.index)
# to_port           = element(var.allowed_udp_ports, count.index)
  for_each          = var.allowed_udp_ports
  from_port         = each.value
  to_port           = each.value
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}

resource "aws_security_group_rule" "egress_udp_ports" {
  type              = "egress"
  count             = length(var.allowed_udp_ports)
  from_port         = element(var.allowed_udp_ports, count.index)
  to_port           = element(var.allowed_udp_ports, count.index)
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}

resource "aws_security_group_rule" "ingress_tcp_ports" {
  type              = "ingress"
  count             = length(var.allowed_tcp_ports)
  from_port         = element(var.allowed_tcp_ports, count.index)
  to_port           = element(var.allowed_tcp_ports, count.index)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}

resource "aws_security_group_rule" "egress_tcp_ports" {
  type              = "egress"
  count             = length(var.allowed_tcp_ports)
  from_port         = element(var.allowed_tcp_ports, count.index)
  to_port           = element(var.allowed_tcp_ports, count.index)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aws_sg.id
}

resource "aws_instance" "vpn" {
  count                       = length(var.list_inst_names)
  ami                         = data.aws_ami_ids.ubuntu.ids[0]
  instance_type               = "t2.nano"
  key_name                    = aws_key_pair.sshpubkey.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.aws_sg.id]

  tags = {
    Name = element(var.list_inst_names, count.index)
  }
}

#resource "aws_route53_record" "aws_vm_dns" {
#  count   = "${length(var.hosts)}"
#  zone_id = "${var.zone_id}"
#  name    = "${element(var.hosts, count.index)}"
#  type    = "A"
#  ttl     = "300"
#  records = ["${element(aws_instance.aws_vm.*.public_ip, count.index)}"]
#}

resource "null_resource" "aws_ansible_inventory" {
  count = length(var.list_inst_names)
  provisioner "local-exec" {
    command = "echo \"[web]\n${element(aws_instance.vpn.*.public_dns, count.index)} ansible_ssh=ubuntu\n\" >> provision/inventory/$NAME"
    environment = {
      NAME = "aws"
    }
  }
  depends_on = ["aws_instance.vpn"]
}

resource "null_resource" "ansible_init" {
  count = length(var.list_inst_names)
  provisioner "local-exec" {
    command = "sleep 15; ansible-playbook -i '${element(aws_instance.vpn.*.public_dns, count.index)},' provision/init.yml"
  }
}

resource "null_resource" "ansible_main" {
  count = length(var.list_inst_names)
  provisioner "local-exec" {
    command = "sleep 150; ansible-playbook -i '${element(aws_instance.vpn.*.public_dns, count.index)},' provision/main.yml"
  }
}

#resource "null_resource" "gen_ansible_inventory" {
#  provisioner "local-exec" {
#    command = templatefile("${path.module}/ansible_inventory.tmpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
#  }
#}

#data "template_file" "ansible_vars" {
#  template = file("./ansible-vars.json.tpl")
#	vars = {
#	  address = aws_instance.vpn.*.public_dns
#	}
#}

#resource "null_resource" "init_provision" {
#  count = length(var.list_inst_names)
#  provisioner "local-exec" {
#	  command = "sleep 10; ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i provision/inventory/aws provision/init.yml --extra-vars @ansible-vars.json"
#  }
##  provisioner "local-exec" {
##	  command = <<EOT
##		"sleep 10;
##		ANSIBLE_HOST_KEY_CHECKING=False;
##		ansible-playbook -i provision/inventory/aws provision/init.yml
##		--extra-vars @ansible-vars.json"
##		EOT
##  }
#}
