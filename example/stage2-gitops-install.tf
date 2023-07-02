module "gitops_install" {
  source = "../"

  cluster_type        = module.cluster.platform.type_code
  ingress_subdomain   = module.cluster.platform.ingress
  tls_secret_name     = module.cluster.platform.tls_secret
  cluster_config_file = module.cluster.config_file_path
  olm_namespace       = module.olm.olm_namespace
  operator_namespace  = module.olm.target_namespace
  sealed_secret_cert  = module.cert.cert
  sealed_secret_private_key = module.cert.private_key
}

resource local_file outputs {
  filename = "${path.cwd}/.outputs"

  content = jsonencode({
    operator_namespace       = module.gitops_install.operator_namespace
    operator_names           = module.gitops_install.operator_names
    argocd_namespace         = module.gitops_install.argocd_namespace
    sealed_secrets_namespace = module.gitops_install.sealed_secrets_namespace
  })
}
