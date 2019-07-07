output Instance_public_dns {
  value       = aws_instance.vpn.*.public_dns
  description = "pub dns"
}

output Security_groups_ID {
  value = aws_security_group.aws_sg.id
}

output Security_groups_name {
  value = aws_security_group.aws_sg.name
}
