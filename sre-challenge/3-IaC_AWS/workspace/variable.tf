variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "az_count" { default = 2 }
variable "cluster_name" { default = "demo-eks" }
variable "cluster_version" { default = "1.29" }
variable "node_group_size" { default = 4 }
variable "node_instance_type" { default = "t3.small" }
