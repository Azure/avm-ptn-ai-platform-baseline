resource "azurerm_private_dns_zone" "vaultcore" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.base.name
}

module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "~> 0.5"

  name                          = local.key_vault_name
  location                      = data.azurerm_resource_group.base.location
  resource_group_name           = data.azurerm_resource_group.base.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = false

  private_endpoints = {
    primary = {
      subnet_resource_id            = module.virtual_network.subnets["private_endpoints"].resource_id
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.vaultcore.id]
      tags                          = var.tags
    }
  }

  role_assignments = {
    deployment_user_secrets = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.current.object_id
    }
  }

  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags
}
