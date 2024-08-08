module "private_dns_storage" {
  for_each            = toset(["blob", "queue", "table", "file"])
  source              = "Azure/avm-res-network-privatednszone/azurerm"
  version             = "~> 0.1.1"
  domain_name         = "privatelink.${each.value}.core.windows.net"
  resource_group_name = data.azurerm_resource_group.base.name
  virtual_network_links = {
    dnslink = {
      vnetlinkname = "storage-${each.value}-vnet-link"
      vnetid       = module.virtual_network.resource.id
    }
  }
  tags             = var.tags
  enable_telemetry = var.enable_telemetry
}

module "storage_account" {

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.2.1"

  account_replication_type      = "LRS"
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  location                      = var.location
  name                          = local.storage_account_name
  resource_group_name           = data.azurerm_resource_group.base.name
  min_tls_version               = "TLS1_2"
  shared_access_key_enabled     = true
  public_network_access_enabled = false
  managed_identities = {
    system_assigned = true
  }
  tags = var.tags

  network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    virtual_network_subnet_ids = [module.virtual_network.subnets["private_endpoints"].resource_id]
  }

  #create a private endpoint for each endpoint type
  private_endpoints = {
    for endoint in toset(["blob", "queue", "table", "file"]) : endoint => {
      name                            = "pe-${endoint}"
      subnet_resource_id              = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids   = [module.private_dns_storage[endoint].resource.id]
      subresource_name                = endoint
      private_service_connection_name = "psc-${endoint}"
      network_interface_name          = "nic-pe-${endoint}"
      inherit_lock                    = true
      tags                            = var.tags
    }
  }
}
