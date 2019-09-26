// agw subnet nsg 
resource "azurerm_network_security_group" "agw_nsg" {
  name                = "${var.agw_subnet_name}-NSG"
  location            = var.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "Allow-ALL-HTTP-Inbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_ranges    = ["80", "443"]
  }

  security_rule {
    name                       = "Allow-ALL-AGW-Inbound"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_ranges    = ["65200-65535"]
  }

  /* CloudFlare IPs
security_rule {
  name                        = "Allow-HTTP-Inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes       = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/12","172.64.0.0/13","131.0.72.0/22"]
  destination_address_prefix  = var.agw_subnet_prefix
  destination_port_ranges      = ["80"]
}

security_rule {
  name                        = "Allow-HTTPS-Inbound"
  priority                    = 301
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes       = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/12","172.64.0.0/13","131.0.72.0/22"]
  destination_address_prefix  = var.agw_subnet_prefix
  destination_port_ranges      = ["443"]
}
*/



  ### Standard Rules

  security_rule {
    name                       = "Allow_LOCAL_SUBNET_INBOUND"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = var.agw_subnet_prefix
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_range     = "*"
  }
  security_rule {
    name                       = "Allow_AZURE_LB_INBOUND"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_range     = "*"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_RDP_INBOUND"
    priority                   = 112
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_range     = "3389"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_SSH_INBOUND"
    priority                   = 113
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_range     = "22"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_WinRM_INBOUND"
    priority                   = 114
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_range     = "5986"
  }
  security_rule {
    name                       = "Allow_RACK_BASTION_SFTBROKER_INBOUND"
    priority                   = 115
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = var.agw_subnet_prefix
    destination_port_range     = "4421"
  }
  security_rule {
    name                       = "Deny_ALL_INBOUND_UDP"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "UDP"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
  security_rule {
    name                       = "Deny_ALL_INBOUND_TCP"
    priority                   = 4001
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "TCP"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}

output "agw_nsg_id" {
  value = azurerm_network_security_group.agw_nsg.id
}

