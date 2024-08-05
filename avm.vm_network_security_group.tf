module "vm_network_security_group" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "~> 0.2.0"
  resource_group_name = data.azurerm_resource_group.base.name
  name                = local.vm_network_security_group_name
  location            = data.azurerm_resource_group.base.location

  security_rules = {
    Allow-AzureBastion-RDP = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "Allow-AzureBastion-RDP"
      priority                   = 100
      protocol                   = "Tcp"
      destination_address_prefix = "Internet"
      destination_port_range     = "3389"
      source_address_prefix      = "AzureBastion"
      source_port_range          = "*"
    }
    Allow-AzureBastion-SSH = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "Allow-AzureBastion-SSH"
      priority                   = 110
      protocol                   = "Tcp"
      destination_address_prefix = "Internet"
      destination_port_range     = "22"
      source_address_prefix      = "AzureBastion"
      source_port_range          = "*"
    }
     Deny-All-Inbound = {
      access                     = "Deny"
      direction                  = "Inbound"
      name                       = "Deny-All-Inbound"
      priority                   = 4096
      protocol                   = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
    Allow-Internet-Outbound = {
      access                     = "Allow"
      direction                  = "Outbound"
      name                       = "Allow-Internet-Outbound"
      priority                   = 100
      protocol                   = "*"
      destination_address_prefix = "Internet"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
    Deny-All-Outbound = {
      access                     = "Deny"
      direction                  = "Outbound"
      name                       = "Deny-Internet-Outbound"
      priority                   = 4096
      protocol                   = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  }

  diagnostic_settings = { for k, v in local.diagnostic_settings : k => {
    name                  = v.name
    workspace_resource_id = v.workspace_resource_id
    metric_categories     = []
    }
  }
  tags = var.tags
}
