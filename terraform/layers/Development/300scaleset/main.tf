###############################################################################
#########################     300scaleset Layer     #########################
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
    key                  = "terraform.development.300scaleset.tfstate"
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
# Scale Sets 01
# https://registry.terraform.io/modules/Azure/loadbalancer/azurerm/1.2.1
# https://registry.terraform.io/modules/Azure/computegroup/azurerm/2.1.0
# If using App Gateway: 
# use module: "../../../modules/terraform-azurerm-vmscaleset-appgw/"
# and parameter: application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids_01
#
# If using Load Balancer: 
# use module: "../../../modules/terraform-azurerm-vmscaleset-lb/"
# and parameter: load_balancer_backend_address_pool_ids = var.load_balancer_backend_address_pool_ids_01
###############################################################################
resource "azurerm_resource_group" "rsg_01" {
  location = var.location
  name     = var.rsg_01
  tags     = local.tags
}

module "scaleset01" {
  source                                       = "../../../modules/terraform-azurerm-vmscaleset-appgw/"
  vmscaleset_name                              = "scaleset01"
  resource_group_name                          = azurerm_resource_group.rsg_01.name
  location                                     = var.location
  vm_size                                      = "Standard_A2"
  admin_username                               = "azureuser"
  admin_password                               = "ComplxP@ssw0rd!"
  nb_instance                                  = 2
  vm_os_simple                                 = "WindowsServer"
  vm_os_id                                     = var.vm_os_id_01
  vm_os_version                                = "latest"
  vnet_subnet_id                               = var.scaleset01_subnet_id
  tags                                         = local.tags
  application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids_01
}

output "scaleset01" {
  value = module.scaleset01
}

###############################################################################
# Scale Sets 02
# https://registry.terraform.io/modules/Azure/loadbalancer/azurerm/1.2.1
# https://registry.terraform.io/modules/Azure/computegroup/azurerm/2.1.0
###############################################################################
resource "azurerm_resource_group" "rsg_02" {
  location = var.location
  name     = var.rsg_02
  tags     = local.tags
}

module "scaleset02" {
  source                                       = "../../../modules/terraform-azurerm-vmscaleset-appgw/"
  vmscaleset_name                              = "scaleset02"
  resource_group_name                          = azurerm_resource_group.rsg_02.name
  location                                     = var.location
  vm_size                                      = "Standard_A2" #"Standard_A0"
  admin_username                               = "azureuser"
  admin_password                               = "ComplxP@ssw0rd!"
  nb_instance                                  = 1
  vm_os_simple                                 = "WindowsServer"
  vm_os_id                                     = var.vm_os_id_02
  vm_os_version                                = "latest"
  vnet_subnet_id                               = var.scaleset02_subnet_id
  tags                                         = local.tags
  application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids_02
}

output "scaleset02" {
  value = module.scaleset02
}

###############################################################################
# Scale Sets 03
# https://registry.terraform.io/modules/Azure/loadbalancer/azurerm/1.2.1
# https://registry.terraform.io/modules/Azure/computegroup/azurerm/2.1.0
###############################################################################
resource "azurerm_resource_group" "rsg_03" {
  location = var.location
  name     = var.rsg_03
  tags     = local.tags
}

/*
module "loadbalancer03" {
  source              = "../../../modules/terraform-azurerm-loadbalancer/"
  resource_group_name = azurerm_resource_group.rsg_03.name
  location            = var.location
  prefix              = "loadbalancer03"
  lb_port = {
    http = ["80", "Tcp", "80"]
  }
}

output "loadbalancer3" {
  value = module.loadbalancer03
}
*/

module "scaleset03" {
  source                                       = "../../../modules/terraform-azurerm-vmscaleset-appgw/"
  vmscaleset_name                              = "scaleset03"
  resource_group_name                          = azurerm_resource_group.rsg_03.name
  location                                     = var.location
  vm_size                                      = "Standard_A2" #"Standard_A0"
  admin_username                               = "azureuser"
  admin_password                               = "ComplxP@ssw0rd!"
  nb_instance                                  = 1
  vm_os_simple                                 = "WindowsServer"
  vm_os_id                                     = var.vm_os_id_03
  vm_os_version                                = "latest"
  vnet_subnet_id                               = local.scaleset03_subnet_id
  tags                                         = local.tags
  application_gateway_backend_address_pool_ids = var.application_gateway_backend_address_pool_ids_03
  #source                                 = "../../../modules/terraform-azurerm-vmscaleset-lb/"
  #load_balancer_backend_address_pool_ids = module.loadbalancer03.azurerm_lb_backend_address_pool_id
  #load_balancer_backend_address_pool_ids = var.load_balancer_backend_address_pool_ids_03
}

output "scaleset03" {
  value = module.scaleset03
}
