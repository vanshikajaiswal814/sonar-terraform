provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}


provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  cluster_ca_certificate = base64decode(
    data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate,
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "azurecli",
      "--server-id",
      var.terraform_server_id
    ]
  }

}

provider "helm" {
  kubernetes {
    host = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
    cluster_ca_certificate = base64decode(
      data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate,
    )

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--login",
        "azurecli",
        "--server-id",
        var.terraform_server_id
      ]
    }
  }
}
