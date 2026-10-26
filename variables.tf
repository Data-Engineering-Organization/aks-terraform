variable "subscription_id" {
  description = "Your Azure subscription ID (run: az account show --query id -o tsv)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "prefix" {
  description = "Short prefix used in all resource names"
  type        = string
  default     = "aom"
}

variable "domain_name" {
  description = "Public domain served by the application (must match host in the Kubernetes Ingress)"
  type        = string
  default     = "aom-service.com"
}

variable "ingress_lb_private_ip" {
  description = "Private IP of the internal Load Balancer created by the ingress controller. Must be inside the AKS subnet and match loadBalancerIP in ingress-nginx-aks.yaml"
  type        = string
  default     = "10.0.1.100"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "appgw_subnet_prefix" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "aks_subnet_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "node_vm_size" {
  description = "VM size for AKS nodes (check availability: az vm list-skus -l centralindia --size Standard_D2s -o table)"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "node_min_count" {
  type    = number
  default = 2
}

variable "node_max_count" {
  type    = number
  default = 4
}

variable "tags" {
  type = map(string)
  default = {
    project     = "aom"
    environment = "dev"
    managed_by  = "terraform"
  }
}
