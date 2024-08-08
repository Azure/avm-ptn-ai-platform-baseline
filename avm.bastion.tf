resource "azurerm_public_ip" "bastion_ip" {
  allocation_method   = "Static"
  location            = var.location
  name                = local.bastion_name
  resource_group_name = data.azurerm_resource_group.base.name
  sku                 = "Standard"
  tags                = var.tags
}

module "azure_bastion" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.3.0"

  enable_telemetry    = var.enable_telemetry
  name                = local.bastion_name
  resource_group_name = data.azurerm_resource_group.base.name
  location            = var.location
  sku                 = "Standard"
  ip_configuration = {
    name                 = "bastion-ip-config"
    subnet_id            = module.virtual_network.subnets["AzureBastionSubnet"].resource_id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
  tags = var.tags
}
