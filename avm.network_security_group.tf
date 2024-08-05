module "ba_network_security_group" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "~> 0.2.0"
  resource_group_name = data.azurerm_resource_group.base.name
  name                = local.bastion_network_security_group_name
  location            = data.azurerm_resource_group.base.location

  security_rules = {
    no_internet = {
      access                     = "Deny"
      direction                  = "Outbound"
      name                       = "block-internet-traffic"
      priority                   = 100
      protocol                   = "*"
      destination_address_prefix = "Internet"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
     allow_bastion_management = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "allow_bastion_management"
      priority                   = 100
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureCloud"
      source_port_range          = "*"
    }
   deny_all_inbound = {
      access                     = "Deny"
      direction                  = "Inbound"
      name                       = "deny_all_inbound"
      priority                   = 4096
      protocol                   = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
   allow_internet_outbound = {
      access                     = "Allow"
      direction                  = "Outbound"
      name                       = "allow_internet_outbound"
      priority                   = 100
      protocol                   = "*"
      destination_address_prefix = "Internet"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    } 
    deny_all_outbound = {
      access                     = "Deny"
      direction                  = "Outbound"
      name                       = "deny_all_outbound"
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
