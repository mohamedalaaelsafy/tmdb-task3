################################
#   K8s Resources Variables    #
################################

#==> NAMESPACES
variable "install_namespaces" {
  type = bool
}
variable "namespaces" {
  type = list(string)
}


#==> ARGOCD
variable "install_argocd" {
  type = bool
}
variable "argocd_version" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "argocd_project" {
  type    = string
  default = ""
}
variable "argocd_app" {
  type    = string
  default = ""
}
variable "argocd_cm" {
  type    = string
  default = ""
}
variable "argocd_secret" {
  type    = string
  default = ""
}

variable "argocd_set_vars" {
  description = "List of set values for Helm chart"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "install_ingress" {
  type = bool
}

# variable "ingress_resource_files" {
#   type = list(string)
# }

# variable "ingress_namespace" {
#   type = string
# }
variable "ingress_version" {
  type    = string
  default = "4.0.1"

}
# variable "ingress_value_file" {
#   type = string
#   default = ""
# }

variable "ingress_set_vars" {
  description = "List of set values for Helm chart"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "ingress_argocd_file" {
  type = string
}