###############################################################################
#########################       000base Layer         #########################
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

locals {
  tags = {
    Environment     = var.environment
    ServiceProvider = "Rackspace"
  }
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
    key                  = "terraform.development.000base.tfstate"
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

###############################################################################
# RSG
###############################################################################

resource "azurerm_resource_group" "rsg" {
  location = var.location
  name     = local.resource_group_name
  tags     = local.tags
}

###############################################################################
# VNET
###############################################################################
locals {
  # Resource Group Name
  resource_group_name = var.resource_group_name

  # location / region
  location = var.location

}

module "vnet" {
  source              = "../../../modules/vnet/"
  resource_group_name = azurerm_resource_group.rsg.name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnet_prefixes     = [var.gateway_subnet_prefix, var.bastion_subnet_prefix, var.scaleset01_subnet_prefix, var.scaleset02_subnet_prefix, var.scaleset03_subnet_prefix, var.appservice01_subnet_prefix, var.appservice02_subnet_prefix, var.dmz_subnet_prefix, var.agw_subnet_prefix]
  subnet_names        = [var.gateway_subnet_name, var.bastion_subnet_name, var.scaleset01_subnet_name, var.scaleset02_subnet_name, var.scaleset03_subnet_name, var.appservice01_subnet_name, var.appservice02_subnet_name, var.dmz_subnet_name, var.agw_subnet_name]

  tags = local.tags
}

locals {
  vnet_id                = module.vnet.vnet_id
  subnet_ids             = module.vnet.vnet_subnets
  gateway_subnet_id      = module.vnet.vnet_subnets[0]
  bastion_subnet_id      = module.vnet.vnet_subnets[1]
  scaleset01_subnet_id   = module.vnet.vnet_subnets[2]
  scaleset02_subnet_id   = module.vnet.vnet_subnets[3]
  scaleset03_subnet_id   = module.vnet.vnet_subnets[4]
  appservice01_subnet_id = module.vnet.vnet_subnets[5]
  appservice02_subnet_id = module.vnet.vnet_subnets[6]
  dmz_subnet_id          = module.vnet.vnet_subnets[7]
  agw_subnet_id          = module.vnet.vnet_subnets[8]
}

###############################################################################
# NSG
###############################################################################

# Rackspace Bastion
module "rbast_nsg" {
  source            = "../../../modules/rbast-nsg/"
  nsg_name          = "${var.bastion_subnet_name}-NSG"
  nsg_location      = var.location
  nsg_rsg           = azurerm_resource_group.rsg.name
  nsg_subnet_prefix = var.bastion_subnet_prefix
}

# Attach Rbast NSG to Bastion Subnet
resource "azurerm_subnet_network_security_group_association" "rbast_nsg" {
  subnet_id                 = local.bastion_subnet_id
  network_security_group_id = module.rbast_nsg.nsg_id
}

locals {
  rbast_nsg_id = module.rbast_nsg.nsg_id
}


# Attach scaleset01 NSG to scaleset01 Subnet
resource "azurerm_subnet_network_security_group_association" "scaleset01_subnet" {
  subnet_id                 = local.scaleset01_subnet_id
  network_security_group_id = azurerm_network_security_group.scaleset01_nsg.id
}

# Attach scaleset02 NSG to scaleset02 Subnet
resource "azurerm_subnet_network_security_group_association" "scaleset02_subnet" {
  subnet_id                 = local.scaleset02_subnet_id
  network_security_group_id = azurerm_network_security_group.scaleset02_nsg.id
}

# Attach scaleset03 NSG to scaleset03 Subnet
resource "azurerm_subnet_network_security_group_association" "scaleset03_subnet" {
  subnet_id                 = local.scaleset03_subnet_id
  network_security_group_id = azurerm_network_security_group.scaleset03_nsg.id
}

# Attach appservice01 NSG to appservice01 Subnet
resource "azurerm_subnet_network_security_group_association" "appservice01_subnet" {
  subnet_id                 = local.appservice01_subnet_id
  network_security_group_id = azurerm_network_security_group.appservice01_nsg.id
}

# Attach appservice02 NSG to appservice02 Subnet
resource "azurerm_subnet_network_security_group_association" "appservice02_subnet" {
  subnet_id                 = local.appservice02_subnet_id
  network_security_group_id = azurerm_network_security_group.appservice02_nsg.id
}

# Attach DMZ NSG to DMZ Subnet
resource "azurerm_subnet_network_security_group_association" "dmz_subnet" {
  subnet_id                 = local.dmz_subnet_id
  network_security_group_id = azurerm_network_security_group.dmz_nsg.id
}

# Attach AGW NSG to AGW Subnet
resource "azurerm_subnet_network_security_group_association" "agw_subnet" {
  subnet_id                 = local.agw_subnet_id
  network_security_group_id = azurerm_network_security_group.agw_nsg.id
}
