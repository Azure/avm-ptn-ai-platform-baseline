resource "azurerm_private_dns_zone" "workspace" {
  name                = "privatelink.workspace.azure.net"
  resource_group_name = data.azurerm_resource_group.base.name
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
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.workspace.id]
      tags                          = var.tags
    }
  }
}
