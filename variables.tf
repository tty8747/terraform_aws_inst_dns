variable "keypath" {
  default     = "~/.ssh/id_rsa.pub"
  description = "path to pub key"
}

variable "allowed_tcp_ports" {
  description = "Allowed ports tcp from/to host"
  type        = "list"
  default     = ["22", "53", "80", "443"]
}

variable "allowed_udp_ports" {
  description = "Allowed ports udp from/to host"
  type        = "list"
  default     = ["53", "1194"]
}

variable "list_inst_names" {
  description = "list of instances names"
  type        = "list"
  default     = ["aaaj.ru", "ubukubu.ru"]
}
