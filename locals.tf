# Define resource names

locals {
  bastion_name                        = replace("ba-${var.name}", "/[^a-zA-Z0-9-]/", "")
  bastion_network_security_group_name = replace("ba-nsg${var.name}", "/[^a-zA-Z0-9-]/", "")
  container_registry_name             = replace("acr${var.name}", "/[^a-zA-Z0-9-]/", "")
  key_vault_name                      = replace("kv${var.name}", "/[^a-zA-Z0-9-]/", "")
  log_analytics_workspace_name        = replace("la${var.name}", "/[^a-zA-Z0-9-]/", "")
  machine_learning_workspace_name     = replace("aml${var.name}", "/[^a-zA-Z0-9-]/", "")
  pe_network_security_group_name      = replace("pe-nsg${var.name}", "/[^a-zA-Z0-9-]/", "")
  resource_group_name                 = length(var.resource_group_name) > 0 ? var.resource_group_name : replace("rg-${var.name}", "/[^a-zA-Z0-9-]/", "")
  storage_account_name                = replace("sa${var.name}", "/[^a-zA-Z0-9-]/", "")
  virtual_network_name                = replace("vnet${var.name}", "/[^a-zA-Z0-9-]/", "")
  vm_network_security_group_name      = replace("vm-nsg${var.name}", "/[^a-zA-Z0-9-]/", "")
}
# Diagnostic settings
locals {
  diagnostic_settings = {
    sendToLogAnalytics = {
      name                  = "sendToLogAnalytics"
      workspace_resource_id = module.log_analytics_workspace.resource.id
    }
  }
}
