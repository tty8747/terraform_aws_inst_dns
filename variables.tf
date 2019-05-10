variable "keypath" {
  default     = "~/.ssh/id_rsa.pub"
  description = "path to pub key"
}

variable "allowed_ports" {
  description = "Allowed ports from/to host"
  type        = "list"
  default     = ["22", "80", "443"]
}
