output "Instance public dns" {
  value       = "${aws_instance.vpn.public_dns}"
  description = "pub dns"
}

output "Security groups ID" {
  value = "${aws_security_group.aws_sg.id}"
}

output "Security groups name" {
  value = "${aws_security_group.aws_sg.name}"
}
