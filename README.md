# Openshift CI/CD module

Module that prepares a cluster for GitOps by installing ArgoCD and KubeSeal via submodules. Both of the submodules
support installation on either OpenShift or vanilla Kubernetes.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v0.15

### Terraform providers

- None

### Submodules

- ArgoCD module - github.com/cloud-native-toolkit/terraform-tools-argocd
- KubeSeal module - github.com/cloud-native-toolkit/terraform-tools-sealed-secrets.git

## Module dependencies

This module makes use of the output from other modules:

- Cluster
- OLM
- Sealed Secret Cert

## Example usage

```hcl-terraform
module "gitops_install" {
  source = "github.com/ibm-garage-cloud/terraform-k8s-gitops-install.git"

  cluster_type        = module.cluster.platform.type_code
  ingress_subdomain   = module.cluster.platform.ingress
  tls_secret_name     = module.cluster.platform.tls_secret
  cluster_config_file = module.cluster.config_file_path
  olm_namespace       = module.olm.olm_namespace
  operator_namespace  = module.olm.target_namespace
  sealed_secret_cert  = module.cert.cert
  sealed_secret_private_key = module.cert.private_key
}
```

