output "Instance public dns" {
  value = "${aws_instance.vpn.public_dns}"
  description = "pub dns"
}
