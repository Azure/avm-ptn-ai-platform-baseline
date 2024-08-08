module "private_dns_container_registry" {
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.1.1"
  domain_name         = "privatelink.azurecr.io"
  resource_group_name = data.azurerm_resource_group.base.name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "container-registry-vnet-link"
      vnetid       = module.virtual_network.resource.id
    }
  }
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "avm_res_containerregistry_registry" {
  source  = "Azure/avm-res-containerregistry-registry/azurerm"
  version = "~> 0.2"

  name                          = local.container_registry_name
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.base.name
  public_network_access_enabled = true
  enable_telemetry              = var.enable_telemetry

  private_endpoints = {
    primary = {
      subnet_resource_id            = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids = [module.private_dns_container_registry.resource.id]
      tags                          = var.tags
    }
  }
  tags = var.tags
}
