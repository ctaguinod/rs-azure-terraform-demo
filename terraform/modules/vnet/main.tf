# Azure Generic vNet Module
# Reference: https://github.com/Azure/terraform-azurerm-vnet 
# Upgraded for 0.12 
resource "azurerm_resource_group" "vnet" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.vnet.name
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_names[count.index]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.vnet.name
  address_prefix       = var.subnet_prefixes[count.index]

  //network_security_group_id = "${lookup(var.nsg_ids,var.subnet_names[count.index],"")}"
  count = length(var.subnet_names)

  lifecycle {
    ignore_changes = [network_security_group_id]
  }
}

