variable "keypath" {
  default     = "~/.ssh/id_rsa.pub"
  description = "path to pub key"
}

variable "allowed_tcp_ports" {
  description = "Allowed ports tcp from/to host"
  type        = list(string)
  default     = ["22", "53", "80", "443"]
}

variable "allowed_udp_ports" {
  description = "Map for test for_each"
  default     = {
    "first"   = 53
    "second"  = 1194
  }
}

variable "list_inst_names" {
  description = "list of instances names"
  type        = list(string)
  default     = ["es00.ru"]
}

