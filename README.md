# Gitops install module

Module that prepares a cluster for GitOps by installing ArgoCD and KubeSeal via submodules. This module
support installation on either OpenShift or vanilla Kubernetes.

ArgoCD provides a GitOps engine to provision other resources on the cluster via resource definitions stored in a git 
repository. KubeSeal provides a way to store sensitive information in a git repository (encrypted "sealed secrets") so 
that the resources can be deployed via gitops. Once these two modules are in place, the rest of the cluster 
configuration can be managed via gitops.

This module performs the following:
- Add the ArgoCD subscription in the cluster-wide operator namespace (`openshift-operators` or `operators`)
- Create an instance of ArgoCD in the default namespace (`openshift-gitops` or `gitops`)
- Create the sealed secrets namespace (by default `sealed-secrets`)
- Provision the KubeSeal instance into the sealed secrets namespace
- Register the private key for the sealed secrets cert with the KubeSeal instance

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v0.15

### Terraform providers

- Clis - cloud-native-toolkit/clis

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
