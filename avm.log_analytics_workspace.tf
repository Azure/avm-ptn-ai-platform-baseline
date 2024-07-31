module "private_dns_workspace" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.1.1"
  domain_name         = "privatelink.workspace.azure.net"
  resource_group_name = data.azurerm_resource_group.base.name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "workspace-vnet-link"
      vnetid       = module.virtual_network.resource.id
    }
  }
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "~> 0.1"

  name                = local.log_analytics_workspace_name
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  tags                = var.tags

  private_endpoints = {
    "pe-log-analytics" = {
      name                          = "pe-log-analytics"
      subnet_resource_id            = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids = [module.private_dns_workspace.resource.id]
      tags                          = var.tags
    }
  }
}
