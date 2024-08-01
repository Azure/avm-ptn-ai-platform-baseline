module "virtual_network" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "~> 0.2.0"
  resource_group_name = data.azurerm_resource_group.base.name
  subnets = {
    AzureBastionSubnet = {
      name                   = "AzureBastionSubnet"
      address_prefixes       = var.azure_bastion_subnet_address_spaces
      network_security_group = local.bastion_network_security_group_name
      service_endpoints      = null
    }
    private_endpoints = {
      name             = "private_endpoints"
      address_prefixes = var.private_endpoints_subnet_address_spaces
      network_security_group = local.pe_network_security_group_name
      private_endpoint_network_policies = "Enabled"
      service_endpoints = [
        "Microsoft.Storage",
        "Microsoft.KeyVault",
        "Microsoft.ServiceBus",
        "Microsoft.AzureCosmosDB",
      ]
    }
    virtual_machines = {
      name                   = "virtual_machines"
      address_prefixes       = var.virtual_machines_subnet_address_spaces
      network_security_group = local.vm_network_security_group_name
      service_endpoints      = null
    }
  }
  address_space       = var.vnet_address_spaces
  location            = var.location
  name                = local.virtual_network_name
  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags
}
