data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "base" {
  name = local.resource_group_name
}
