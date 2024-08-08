module "aml" {
  source   = "Azure/avm-res-machinelearningservices-workspace/azurerm"
  version  = "0.1.1"
  location = var.location
  name     = local.machine_learning_workspace_name
  resource_group = {
    id   = data.azurerm_resource_group.base.id
    name = data.azurerm_resource_group.base.name
  }
  storage_account = {
    resource_id = module.storage_account.resource.id
    create_new  = false
  }
  key_vault = {
    resource_id = replace(module.key_vault.resource_id, "Microsoft.KeyVault", "Microsoft.Keyvault")
    create_new  = false
  }

  container_registry = {
    resource_id = module.avm_res_containerregistry_registry.resource.id
    create_new  = false
  }

  enable_telemetry = var.enable_telemetry
  tags             = var.tags
  is_private       = true
}
