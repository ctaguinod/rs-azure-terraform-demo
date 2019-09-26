###############################################################################
#########################        500appgw Layer       #########################
###############################################################################

###############################################################################
# Providers
###############################################################################
provider "azurerm" {
  version         = ">=1.33"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

###############################################################################
# Use Terraform Version 0.12
# Obtain storage access_key from storage account or 
# az storage account keys list -g MyResourceGroup -n MyStorageAccount
# Linux:   export ARM_ACCESS_KEY=XXXXXYYYYYYY
# Windows: $env:ARM_ACCESS_KEY="XXXYYY"
###############################################################################

terraform {
  required_version = ">= 0.12"

  backend "azurerm" {
    storage_account_name = "terraform92f44ca7"
    container_name       = "terraform-state"
    key                  = "terraform.development.500aoogw.tfstate"
  }
}

###############################################################################
# Terraform Remote State 
###############################################################################
data "terraform_remote_state" "main_state" {
  backend = "local"

  config = {
    path = "../../_main/terraform.tfstate"
  }
}

data "terraform_remote_state" "base_network" {
  backend = "azurerm"

  config = {
    storage_account_name = "terraform92f44ca7"
    container_name       = "terraform-state"
    key                  = "terraform.development.000base.tfstate"
  }
}

locals {
  vnet_id                = data.terraform_remote_state.base_network.outputs.vnet.vnet_id
  subnet_ids             = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets
  gateway_subnet_id      = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[0]
  bastion_subnet_id      = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[1]
  scaleset01_subnet_id   = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[2]
  scaleset02_subnet_id   = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[3]
  scaleset03_subnet_id   = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[4]
  appservice01_subnet_id = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[5]
  appservice02_subnet_id = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[6]
  dmz_subnet_id          = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[7]
  appgw_subnet_id        = data.terraform_remote_state.base_network.outputs.vnet.vnet_subnets[8]
}

###############################################################################
# Locals
###############################################################################
locals {
  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
}

###############################################################################
# RSG
###############################################################################
resource "azurerm_resource_group" "rsg" {
  location = var.location
  name     = var.resource_group_name
  tags     = local.tags
}

###############################################################################
# Application Gateway
# https://www.terraform.io/docs/providers/azurerm/r/application_gateway.html
###############################################################################
resource "azurerm_public_ip" "agw01" {
  name                = "${var.agw_name}-pip"
  resource_group_name = azurerm_resource_group.rsg.name
  location            = var.location
  allocation_method   = "Dynamic"
}

locals {
  backend_address_pool_name      = "${var.agw_name}-beap"
  frontend_port_name             = "${var.agw_name}-feport"
  frontend_ip_configuration_name = "${var.agw_name}-feip"
  http_setting_name              = "${var.agw_name}-be-htst"
  listener_name                  = "${var.agw_name}-httplstn"
  request_routing_rule_name      = "${var.agw_name}-rqrt"
  redirect_configuration_name    = "${var.agw_name}-rdrcfg"
}

resource "azurerm_application_gateway" "agw01" {
  name                = var.agw_name
  resource_group_name = azurerm_resource_group.rsg.name
  location            = var.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${var.agw_name}-gateway-ip-configuration"
    subnet_id = var.vnet_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw01.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

output "agw01" {
  value = azurerm_application_gateway.agw01
}
