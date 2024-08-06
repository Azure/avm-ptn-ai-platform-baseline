module "ba_network_security_group" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "~> 0.2.0"
  resource_group_name = data.azurerm_resource_group.base.name
  name                = local.bastion_network_security_group_name
  location            = data.azurerm_resource_group.base.location

  security_rules = {

    # -- Inbound rules --

    AllowHttpsInbound = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "AllowHttpsInbound"
      priority                   = 120
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
    }
    AllowGatewayManagerInbound = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "AllowGatewayManagerInbound"
      priority                   = 130
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      source_port_range          = "*"
    }
    AllowAzureLoadBalancerInbound = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "AllowAzureLoadBalancerInbound"
      priority                   = 140
      protocol                   = "Tcp"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer"
      source_port_range          = "*"
    }
    AllowBastionHostCommunication = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "AllowBastionHostCommunication"
      priority                   = 150
      protocol                   = "Tcp"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    }

    DenyAllInbound = {
      access                     = "Deny"
      direction                  = "Inbound"
      name                       = "DenyAllInbound"
      priority                   = 1000
      protocol                   = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }

    # -- Outbound rules --

    AllowSshRdpOutbound = {
      access                     = "Allow"
      direction                  = "Outbound"
      name                       = "AllowSshRdpOutbound"
      priority                   = 120
      protocol                   = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges    = ["22", "3389"]
      source_address_prefix      = "*"
      source_port_range          = "*"
    }

    AllowAzureCloudOutbound = {
      access                     = "Allow"
      direction                  = "Outbound"
      name                       = "AllowAzureCloudOutbound"
      priority                   = 130
      protocol                   = "Tcp"
      destination_address_prefix = "AzureCloud"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }

    AllowBastionCommunicaton = {
      access                     = "Allow"
      direction                  = "Outbound"
      name                       = "AllowBastionCommunicaton"
      priority                   = 140
      protocol                   = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    }

    AllowHttpOutbound = {
      access                     = "Allow"
      direction                  = "Outbound"
      name                       = "AllowHttpOutbound"
      priority                   = 150
      protocol                   = "Tcp"
      destination_address_prefix = "Internet"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }

    DenyAllOutbound = {
      access                     = "Deny"
      direction                  = "Outbound"
      name                       = "DenyAllOutbound"
      priority                   = 1000
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

module "vm_network_security_group" {
  source              = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version             = "~> 0.2.0"
  resource_group_name = data.azurerm_resource_group.base.name
  name                = local.vm_network_security_group_name
  location            = data.azurerm_resource_group.base.location

  security_rules = {
    AllowAzureBastion = {
      access                     = "Allow"
      direction                  = "Inbound"
      name                       = "Allow-AzureBastion"
      priority                   = 100
      protocol                   = "Tcp"
      destination_address_prefix = "Internet"
      destination_port_ranges    = ["3389", "22"]
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    }
    DenyAllInbound = {
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

    AllowInternetOutbound = {
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

    DenyAllOutbound = {
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
