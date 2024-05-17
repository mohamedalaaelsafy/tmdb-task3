################################
#       Global Variables       #
################################
variable "project_id" { type = string }

variable "region" { type = string }

variable "zone" { type = string }

variable "app" { type = string }

variable "env" { type = string }

################################
#     GKE Module Variables     #
################################


variable "name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "vpc_name" {
  type = string
}


variable "node_locations" {
  type        = string
  description = "node locations in the node pool"
}

variable "master_authorized_networks" {
  type = list(object({ cidr_block = string, display_name = string }))
}

variable "subnet_cidr_sec1" {
  type = string
}

variable "subnet_cidr_sec2" {
  type = string
}

variable "master_node_cidr" {
  type = string
}

variable "node_pools" {
  type = any
  # default = []
}