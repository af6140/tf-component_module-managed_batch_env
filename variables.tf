variable "app_tier" {
  type = "string"
}

variable "service" {
  type = "string"
}


variable "instance_types" {
  type = "string"
  default = ["m5.large"]
}

variable "max_vcpus" {
  type = "string"
}

variable "min_vcpus" {
  type = "string"
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
