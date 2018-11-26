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

variable "service_role_arn" {
  type = "string"
}

variable "instance_role_arn" {
  type = "string"
}

variable "compute_resource_type" {
  type        = "stirng"
  description = "ENUM(EC2, SPOT)"
  default     = "EC2"
}

variable "bid_percentage" {
  type    = "string"
  default = "20"
}

variable "spot_iam_fleet_role" {
  type    = "string"
  default = ""
}
