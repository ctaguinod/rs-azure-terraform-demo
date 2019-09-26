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

variable "vnet_subnet_id" {
  description = "Subnet ID"
}


###############################################################################
# App Service 01
###############################################################################
variable "rsg_01" {
  description = "Resource Group Name 01"
}

variable "web_app_01_name" {
  description = "Web App 01 Name"
}

###############################################################################
# App Service 02
###############################################################################
variable "rsg_02" {
  description = "Resource Group Name 02"
}

variable "web_app_02_name" {
  description = "Web App 02 Name"
}

