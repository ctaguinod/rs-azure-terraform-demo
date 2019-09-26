###############################################################################
#########################        600sql Layer        #########################
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
    key                  = "terraform.development.600sql.tfstate"
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

  # Random id
  random_id = "${lower(random_id.storage.hex)}"
}

resource "random_id" "storage" {
  byte_length = 4
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
# SQL
# https://www.terraform.io/docs/providers/azurerm/r/sql_database.html
###############################################################################
resource "azurerm_sql_server" "testsql" {
  name                         = "${var.sql_server_name}${local.random_id}"
  resource_group_name          = azurerm_resource_group.rsg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "testdb" {
  name                = var.sql_database_name
  resource_group_name = azurerm_resource_group.rsg.name
  location            = var.location
  server_name         = azurerm_sql_server.testsql.name
  tags                = local.tags
}

resource "azurerm_sql_firewall_rule" "testsql" {
  name                = "${var.sql_server_name}FirewallRule1"
  resource_group_name = azurerm_resource_group.rsg.name
  server_name         = azurerm_sql_server.testsql.name
  start_ip_address    = "116.12.183.34"
  end_ip_address      = "116.12.183.34"
}