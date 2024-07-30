module "private_dns_zones" {
  # replace source with the correct link to the private_dns_zones module
  # source                = "Azure/avm-res-network-privatednszone/azurerm"  
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.1.2"
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
