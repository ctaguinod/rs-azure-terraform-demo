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

variable "resource_group_name" {
  description = "Resource Group Name"
}

###############################################################################
# VNET
###############################################################################

variable "vnet_name" {
  description = "VNET Name"
  default     = "SEA-VNET01"
}

variable "address_space" {
  description = "VNET Address Space"
  default     = "172.18.0.0/16"
}

variable "gateway_subnet_prefix" {
  description = "GatewaySubnet Prefix"
  default     = "172.18.1.0/27"
}

variable "gateway_subnet_name" {
  description = "GatewaySubnet Name"
  default     = "GatewaySubnet"
}

variable "bastion_subnet_prefix" {
  description = "RAX Bastion Subnet Prefix"
  default     = "172.18.2.0/24"
}

variable "bastion_subnet_name" {
  description = "RAX Bastion Subnet Name"
  default     = "RAX-BASTION-SUBNET"
}

variable "scaleset01_subnet_prefix" {
  description = "Scale Set 01 Subnet Prefix"
  default     = "172.18.11.0/24"
}

variable "scaleset01_subnet_name" {
  description = "Scale Set 01 Subnet Name"
  default     = "SCALESET01-SUBNET"
}

variable "scaleset02_subnet_prefix" {
  description = "Scale Set 02 Subnet Prefix"
  default     = "172.18.12.0/24"
}

variable "scaleset02_subnet_name" {
  description = "Scale Set 02 Subnet Name"
  default     = "SCALESET02-SUBNET"
}

variable "scaleset03_subnet_prefix" {
  description = "Scale Set 03 Subnet Prefix"
  default     = "172.18.13.0/24"
}

variable "scaleset03_subnet_name" {
  description = "Scale Set 03 Subnet Name"
  default     = "SCALESET03-SUBNET"
}

variable "appservice01_subnet_prefix" {
  description = "App Service 01 Subnet Prefix"
  default     = "172.18.21.0/24"
}

variable "appservice01_subnet_name" {
  description = "App Service 01 Subnet Name"
  default     = "APPSERVICE01-SUBNET"
}

variable "appservice02_subnet_prefix" {
  description = "App Service 02 Subnet Prefix"
  default     = "172.18.22.0/24"
}

variable "appservice02_subnet_name" {
  description = "App Service 02 Subnet Name"
  default     = "APPSERVICE02-SUBNET"
}

variable "dmz_subnet_prefix" {
  description = "DMZ Subnet Prefix"
  default     = "172.18.30.0/24"
}

variable "dmz_subnet_name" {
  description = "DMZ Subnet Name"
  default     = "DMZ-SUBNET"
}

variable "agw_subnet_prefix" {
  description = "DMZ Subnet Prefix"
  default     = "172.18.40.0/24"
}

variable "agw_subnet_name" {
  description = "AGW Subnet Name"
  default     = "AGW-SUBNET"
}