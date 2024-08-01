module "aml" {
  source   = "Azure/avm-res-machinelearningservices-workspace/azurerm"
  version  = "0.1.1"
  location = data.azurerm_resource_group.base.location
  name     = local.machine_learning_workspace_name
  resource_group = {
    id   = data.azurerm_resource_group.base.id
    name = data.azurerm_resource_group.base.name
  }
  storage_account = {
    resource_id = module.storage_account.resource.id
  }
  key_vault = {
    resource_id = module.key_vault.resource_id
  }
  enable_telemetry = var.enable_telemetry
  tags             = var.tags
}
