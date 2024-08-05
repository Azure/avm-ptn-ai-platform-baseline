# Define resource names

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4.1"
  prefix  = [var.name]
  suffix  = length(var.suffix) > 0 ? [var.suffix] : []
}

locals {
  bastion_name                        = module.naming.bastion_host.name_unique
  key_vault_name                      = module.naming.key_vault.name_unique
  log_analytics_workspace_name        = module.naming.log_analytics_workspace.name_unique
  machine_learning_workspace_name     = module.naming.machine_learning_workspace.name_unique
  bastion_network_security_group_name = "${module.naming.network_security_group.name_unique}-ba"
  vm_network_security_group_name      = "${module.naming.network_security_group.name_unique}-vm"
  pe_network_security_group_name      = "${module.naming.network_security_group.name_unique}-pe"
  public_ip_bastion_name              = module.naming.public_ip.name_unique
  resource_group_name                 = length(var.resource_group_name) > 0 ? var.resource_group_name : module.naming.resource_group.name_unique
  storage_account_name                = module.naming.storage_account.name_unique
  virtual_network_name                = module.naming.virtual_network.name_unique
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
