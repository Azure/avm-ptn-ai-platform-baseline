module "pe_network_security_group" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "~> 0.2.0"
  resource_group_name = data.azurerm_resource_group.base.name
  name                = local.pe_network_security_group_name
  location            = data.azurerm_resource_group.base.location

  security_rules = {
    no_internet = {
      access                     = "Deny"
      direction                  = "Outbound"
      name                       = "block-internet-traffic"
      priority                   = 200
      protocol                   = "*"
      destination_address_prefix = "Internet"
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
