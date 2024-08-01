# TODO: insert locals here.
# Define resource names
locals {
  key_vault_name               = "kv-bridge-${format("%.16s", local.unique_postfix)}"
  log_analytics_workspace_name = "log-analytics-pattern-${local.unique_postfix}"
  network_security_group_name  = "nsg-bridge-${local.unique_postfix}"
  resource_group_name          = "rg-pattern-${local.unique_postfix}"
  unique_postfix               = random_pet.unique_name.id
  virtual_network_name         = "vnet-bridge-${local.unique_postfix}"
}
# Caluculate the CIDR for the subnets
locals {
  cidr_subnets    = cidrsubnets(local.virtual_network_address_space, local.subnet_new_bits...)
  skip_nsg        = ["AzureBastionSubnet", "virtual_machines"]
  subnet_keys     = keys(var.subnets_and_sizes)
  subnet_new_bits = [for size in values(var.subnets_and_sizes) : size - var.address_space_size]
  subnets = { for key, value in var.subnets_and_sizes : key => {
    name             = key
    address_prefixes = [local.cidr_subnets[index(local.subnet_keys, key)]]
    network_security_group = contains(local.skip_nsg, key) ? null : {
      id = module.network_security_group.resource_id
    }
    }
  }
  virtual_network_address_space = "${var.address_space_start_ip}/${var.address_space_size}"
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

locals {
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
  # Private endpoint application security group associations.
  # We merge the nested maps from private endpoints and application security group associations into a single map.
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
}
