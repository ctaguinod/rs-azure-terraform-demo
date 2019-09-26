###############################################################################
#########################     400appservice Layer     #########################
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
    key                  = "terraform.development.400appservice.tfstate"
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
# Azure App Service - 01
# https://registry.terraform.io/modules/innovationnorway/web-app/azurerm/1.0.0
# https://github.com/innovationnorway/terraform-azurerm-web-app
###############################################################################

resource "azurerm_resource_group" "rsg_01" {
  location = var.location
  name     = var.rsg_01
  tags     = local.tags
}

module "webapp01" {
  source              = "innovationnorway/web-app/azurerm"
  version             = "1.0.0"
  name                = var.web_app_01_name
  resource_group_name = azurerm_resource_group.rsg_01.name

  runtime = {
    name    = "dotnetcore"
    version = "2.2"
  }

  plan = {
    sku_size = "B1"
  }
}

###############################################################################
# Azure App Service - 02
# https://registry.terraform.io/modules/innovationnorway/web-app/azurerm/1.0.0
# https://github.com/innovationnorway/terraform-azurerm-web-app
###############################################################################

resource "azurerm_resource_group" "rsg_02" {
  location = var.location
  name     = var.rsg_02
  tags     = local.tags
}

module "webapp02" {
  source              = "innovationnorway/web-app/azurerm"
  version             = "1.0.0"
  name                = var.web_app_02_name
  resource_group_name = azurerm_resource_group.rsg_02.name

  runtime = {
    name    = "aspnet"
    version = "4.7"
  }

  plan = {
    sku_size = "B1"
  }
}