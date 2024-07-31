resource "azurerm_private_dns_zone" "storage_queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = data.azurerm_resource_group.base.name
}

resource "azurerm_private_dns_zone" "storage_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = data.azurerm_resource_group.base.name
}

resource "azurerm_private_dns_zone" "storage_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = data.azurerm_resource_group.base.name
}

resource "azurerm_private_dns_zone" "storage_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.base.name
}

module "storage_account" {

  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.2.1"

  account_replication_type      = "LRS"
  account_tier                  = "Standard"
  account_kind                  = "StorageV2"
  location                      = data.azurerm_resource_group.base.location
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
    "blob" = {
      name                            = "pe-blob"
      subnet_resource_id              = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids   = [azurerm_private_dns_zone.storage_blob.id]
      subresource_name                = "blob"
      private_service_connection_name = "psc-blob"
      network_interface_name          = "nic-pe-blob"
      inherit_lock                    = true
      tags                            = var.tags
    }
    "queue" = {
      name                            = "pe-queue"
      subnet_resource_id              = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids   = [azurerm_private_dns_zone.storage_queue.id]
      subresource_name                = "queue"
      private_service_connection_name = "psc-queue"
      network_interface_name          = "nic-pe-queue"
      inherit_lock                    = true
      tags                            = var.tags
    },
    "table" = {
      name                            = "pe-table"
      subnet_resource_id              = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids   = [azurerm_private_dns_zone.storage_table.id]
      subresource_name                = "table"
      private_service_connection_name = "psc-table"
      network_interface_name          = "nic-pe-table"
      inherit_lock                    = true
      tags                            = var.tags
    },
    "file" = {
      name                            = "pe-file"
      subnet_resource_id              = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids   = [azurerm_private_dns_zone.storage_file.id]
      subresource_name                = "file"
      private_service_connection_name = "psc-file"
      network_interface_name          = "nic-pe-file"
      inherit_lock                    = true
      tags                            = var.tags
    }
  }
}
