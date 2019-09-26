###############################################################################
# Environment
###############################################################################

variable "subscription_name" {
  description = "Enter Subscription Name for provisioning resources in Azure"
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}
variable "location" {
  description = "Azure region the environment."
  default     = "Southeast Asia"
}

variable "environment" {
  description = "Name of the environment for the deployment, e.g. Integration, PreProduction, Production, QA, Staging, Test"
  default     = "Development"
}

###############################################################################
# Subnet
###############################################################################

###############################################################################
# Scale Sets 01
###############################################################################
variable "scaleset01_subnet_id" {
  description = "Scaleset 01 Subnet ID"
}

variable "rsg_01" {
  description = "Resource Group Name 01"
}
variable "vm_os_id_01" {
  description = "Custom VM Image to use."
}

variable "load_balancer_backend_address_pool_ids_01" {
  description = "The id of the backend address pools of the loadbalancer to which the VM scale set is attached"
  default     = ""
}

variable "application_gateway_backend_address_pool_ids_01" {
  description = "The id of the backend address pools of the application gateway to which the VM scale set is attached"
  default     = ""
}

###############################################################################
# Scale Sets 02
###############################################################################
variable "scaleset02_subnet_id" {
  description = "Scaleset 02 Subnet ID"
}
variable "rsg_02" {
  description = "Resource Group Name 02"
}

variable "vm_os_id_02" {
  description = "Custom VM Image to use."
}

variable "load_balancer_backend_address_pool_ids_02" {
  description = "The id of the backend address pools of the loadbalancer to which the VM scale set is attached"
  default     = ""
}

variable "application_gateway_backend_address_pool_ids_02" {
  description = "The id of the backend address pools of the application gateway to which the VM scale set is attached"
  default     = ""
}

###############################################################################
# Scale Sets 03
###############################################################################
variable "scaleset03_subnet_id" {
  description = "Scaleset 03 Subnet ID"
}

variable "rsg_03" {
  description = "Resource Group Name 03"
}

variable "vm_os_id_03" {
  description = "Custom VM Image to use."
}

variable "load_balancer_backend_address_pool_ids_03" {
  description = "The id of the backend address pools of the loadbalancer to which the VM scale set is attached"
  default     = ""
}

variable "application_gateway_backend_address_pool_ids_03" {
  description = "The id of the backend address pools of the application gateway to which the VM scale set is attached"
  default     = ""
}