################################
#      Create Namespaces       #
################################
resource "kubernetes_namespace" "namespaces" {
  count    = var.install_namespaces ? length(var.namespaces) : 0
  provider = kubernetes
  metadata {
    name = var.namespaces[count.index]
  }
}

################################
#        Install ArgoCD        #
################################

resource "helm_release" "argo_cd" {
  count            = var.install_argocd ? 1 : 0
  provider         = helm
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  namespace        = "argocd"
  create_namespace = true
  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "server.service.nodePort"
    value = "32000"
  }
  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  dynamic "set" {
    for_each = var.argocd_set_vars
    content {
      name  = set.value.name
      value = set.value.value
    }
  }


}

#==> AUTHENTICATE PRIVATE REPOSETORY
resource "kubectl_manifest" "argocd-secret" {
  count              = var.install_argocd && var.argocd_secret != "" && var.argocd_secret != null ? 1 : 0
  yaml_body          = file(var.argocd_secret)
  override_namespace = helm_release.argo_cd[0].namespace
  depends_on         = [helm_release.argo_cd]
}

#==> REPLACE THE DEFAULT CONFIG MAP
resource "kubectl_manifest" "argocd-config_map" {
  count              = var.install_argocd && var.argocd_cm != "" && var.argocd_cm != null ? 1 : 0
  yaml_body          = file(var.argocd_cm)
  override_namespace = helm_release.argo_cd[0].namespace
  depends_on         = [helm_release.argo_cd]
}

#==> CREATE APPLICATION IN ARGOCD
resource "kubectl_manifest" "argocd-app" {
  count              = var.install_argocd && var.argocd_app != "" && var.argocd_app != null ? 1 : 0
  yaml_body          = file(var.argocd_app)
  override_namespace = helm_release.argo_cd[0].namespace
  depends_on         = [helm_release.argo_cd]
}

#==> CREATE PROJECT IN ARGOCD
resource "kubectl_manifest" "argocd-project" {
  count              = var.install_argocd && var.argocd_project != "" && var.argocd_project != null ? 1 : 0
  yaml_body          = file(var.argocd_project)
  override_namespace = helm_release.argo_cd[0].namespace
  depends_on         = [helm_release.argo_cd]
}

################################
#        Install Ingress       #
################################

#==> INSTALL INGRESS
resource "helm_release" "ingress_nginx" {
  count      = var.install_ingress ? 1 : 0
  provider   = helm
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_version

  set {
    name  = "installCRDs"
    value = "true"
  }
  dynamic "set" {
    for_each = var.ingress_set_vars
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
  depends_on = [helm_release.argo_cd]
}

#==> INSTALL INGRESS RESOURCE FOR ARGOCD
resource "kubectl_manifest" "ingress-argocd" {
  count              = var.install_argocd && var.install_ingress ? 1 : 0
  yaml_body          = file(var.ingress_argocd_file)
  override_namespace = helm_release.argo_cd[0].namespace
  depends_on         = [helm_release.argo_cd, helm_release.ingress_nginx]
}











# resource "helm_release" "nginx_ingress" {
#   provider = helm
#   count              = var.install_ingress ? 1 : 0
#   name       = "nginx-ingress"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   # version    = " 1.2.1"  # Use an appropriate version

#   # dynamic "set" {
#   #   for_each = var.ingress_set_vars
#   #   content {
#   #     name  = set.value.name
#   #     value = set.value.value
#   #   }
#   # }

#   # values = [
#   #   "${file("${var.ingress_value_file}")}"
#   # ]
# } 