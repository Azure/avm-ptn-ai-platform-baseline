module "private_dns_zones" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.1"
  enable_telemetry      = var.enable_telemetry
  resource_group_name   = data.azurerm_resource_group.base.name
  domain_name           = local.domain_name
  tags                  = var.tags
  virtual_network_links = {
    vnetlink1 = {
      vnetlinkname = "main-vnet"
      vnetid       = module.virtual_network.resource_id
    }
  }
}
