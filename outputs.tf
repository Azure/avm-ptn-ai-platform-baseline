output "names" {
  value = {
    resource_group_name         = local.resource_group_name
    virtual_network_name        = local.virtual_network_name
    network_security_group_name = local.network_security_group_name
    key_vault_name              = local.key_vault_name
  }
}

# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "resource" {
  description = "This is the full output for the resource."
  value = {
    resource_group = data.azurerm_resource_group.base
  }
}

output "subnets" {
  value = local.subnets
}
