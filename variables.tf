variable "location" {
  type        = string
  description = "The location/region where the resources will be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the this resource."

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{4,14}$", var.name))
    error_message = "The name must be between 5 and 15 chars long and can only contain lowercase letters and numbers."
  }
}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "azure_bastion_subnet_address_spaces" {
  type        = list(string)
  default     = ["10.1.3.0/24"]
  description = "The address space that is used for the Azure Bastion subnet"
}

variable "bastion_name" {
  type        = string
  default     = ""
  description = "The name of the Azure Bastion resource. if not provided, a name will be generated."
}

variable "bastion_network_security_group_name" {
  type        = string
  default     = ""
  description = "The name of the Network Security Group for the Azure Bastion subnet. If not provided, a name will be generated."
}

variable "container_registry_name" {
  type        = string
  default     = ""
  description = "The name of the Azure Container Registry. If not provided, a name will be generated."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "key_vault_name" {
  type        = string
  default     = ""
  description = "The name of the Azure Key Vault. If not provided, a name will be generated."
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "log_analytics_workspace_name" {
  type        = string
  default     = ""
  description = "The name of the Log Analytics Workspace. If not provided, a name will be generated."
}

variable "machine_learning_workspace_name" {
  type        = string
  default     = ""
  description = "The name of the Azure Machine Learning Workspace. If not provided, a name will be generated."
}

variable "pe_network_security_group_name" {
  type        = string
  default     = ""
  description = "The name of the Network Security Group for the private endpoints subnet. If not provided, a name will be generated."
}

variable "private_endpoints_subnet_address_spaces" {
  type        = list(string)
  default     = ["10.1.2.0/24"]
  description = "The address space that is used for the private endpoints subnet"
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
  A map of role assignments to create on the <RESOURCE>. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  
  - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
  - `principal_id` - The ID of the principal to assign the role to.
  - `description` - (Optional) The description of the role assignment.
  - `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
  - `condition` - (Optional) The condition which will be used to scope the role assignment.
  - `condition_version` - (Optional) The version of the condition syntax. Leave as `null` if you are not using a condition, if you are then valid values are '2.0'.
  - `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. This field is only used in cross-tenant scenario.
  - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.
  
  > Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
  DESCRIPTION
  nullable    = false
}

variable "storage_account_name" {
  type        = string
  default     = ""
  description = "The name of the Azure Storage Account. If not provided, a name will be generated."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to add to all resources"
}

variable "virtual_machines_subnet_address_spaces" {
  type        = list(string)
  default     = ["10.1.1.0/24"]
  description = "The address space that is used for the virtual machines subnet"
}

variable "virtual_network_name" {
  type        = string
  default     = ""
  description = "The name of the Virtual Network. If not provided, a name will be generated."
}

variable "vm_network_security_group_name" {
  type        = string
  default     = ""
  description = "The name of the Network Security Group for the virtual machines subnet. If not provided, a name will be generated."
}

variable "vnet_address_spaces" {
  type        = list(string)
  default     = ["10.1.0.0/16"]
  description = "The address space that is used the virtual network"
}
