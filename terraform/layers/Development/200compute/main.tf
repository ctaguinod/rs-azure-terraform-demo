###############################################################################
#########################       200compute Layer      #########################
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
    key                  = "terraform.development.200compute.tfstate"
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

  # Subnet ID
  vnet_subnet_id = local.scaleset01_subnet_id
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
# VM
###############################################################################

module "mytestvm" {
  source                       = "../../../modules/terraform-azurerm-compute/"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  vnet_subnet_id               = local.vnet_subnet_id
  vm_hostname                  = "mytestvm" // line can be removed if only one VM module per resource group
  admin_username               = "mytestvm"
  admin_password               = "ComplxP@ssw0rd!"
  public_ip_dns                = ["mytestvm"] // change to a unique name per datacenter region
  public_ip_address_allocation = "Dynamic"
  nb_public_ip                 = "1"
  nb_instances                 = "1"
  vm_os_simple                 = "WindowsServer"
  vm_os_publisher              = "MicrosoftWindowsServer"
  vm_os_offer                  = "WindowsServer"
  vm_size                      = "Standard_B2s"
  vm_os_id                     = var.vm_os_id
  is_windows_image             = "true"
  storage_account_type         = "Standard_LRS"
  tags                         = local.tags
}

output "mytestvm" {
  value       = module.mytestvm
  description = "mytestvm Output"
}

