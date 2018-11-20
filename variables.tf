variable "app_tier" {
  type = "string"
}

variable "service" {
  type = "string"
}

variable "vpc_name" {
  type = "string"
}

variable "instance_types" {
  type    = "list"
  default = ["m5a.large"]
}

variable "max_vcpus" {
  type = "string"
}

variable "min_vcpus" {
  type    = "string"
  default = "0"
}

variable "security_group_ids" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}

variable "ssh_key_name" {
  type = "string"
}
