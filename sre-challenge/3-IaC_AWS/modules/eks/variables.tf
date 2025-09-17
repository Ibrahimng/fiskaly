variable "cluster_name" {}
variable "cluster_version" {}
variable "vpc_id" {}
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "node_group_size" { default = 4 }
variable "node_instance_type" { default = "t3.small" }
