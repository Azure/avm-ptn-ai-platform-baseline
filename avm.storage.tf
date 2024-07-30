module "this" {

  source  = "Azure/avm-res-storage-storageaccount/azurerm//examples/private-endpoint"
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
    system_assigned            = true
  }
  tags = var.tags
  
  network_rules = {
    bypass                     = ["AzureServices"]
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.private.id]
  }

  #create a private endpoint for each endpoint type
  private_endpoints = {
    for endpoint in local.storage_endpoints :
    endpoint => {
      # the name must be set to avoid conflicting resources.
      name                          = "pe-${endpoint}-${module.naming.storage_account.name_unique}"
      subnet_resource_id            = azurerm_subnet.private.id
      subresource_name              = endpoint
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.this[endpoint].id]
      # these are optional but illustrate making well-aligned service connection & NIC names.
      private_service_connection_name = "psc-${endpoint}-${module.naming.storage_account.name_unique}"
      network_interface_name          = "nic-pe-${endpoint}-${module.naming.storage_account.name_unique}"
      inherit_lock                    = false

      tags = var.tags
    }


  }

}
