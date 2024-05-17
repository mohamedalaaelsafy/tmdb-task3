################################
#       Global Variables       #
################################
variable "project_id" { type = string }

variable "region" { type = string  }

variable "zone" { type = string }

variable "app" { type = string }

variable "env" { type = string }

################################
#       Network Variables      #
################################
variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "subnet_cidr_sec1" {
  type = string
}

variable "subnet_cidr_sec2" {
  type = string
}
