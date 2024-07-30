module "log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "~> 0.1"

  name                = local.log_analytics_workspace_name
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  tags                = var.tags

  private_endpoints = {
    pe1 = {
      name = "log-analytics-pe"
      private_dns_zone_resource_ids = [module.private_dns_zone_key_vault.resource_id]
      subnet_resource_id            = module.virtual_network.subnets["private_endpoints"].resource_id
    }
  }
}
