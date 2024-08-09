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

module "jumpbox" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.15.1"

  enable_telemetry    = var.enable_telemetry
  location            = var.location
  resource_group_name = local.resource_group_name
  os_type             = var.jumpbox.os_type
  name                = var.jumpbox.name
  sku_size            = var.jumpbox.size
  zone                = var.jumpbox.zone

  source_image_reference = var.jumpbox.image_ref

  network_interfaces = {
    network_interface_1 = {
      name = "${var.jumpbox.name}-nic"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${var.jumpbox.name}-nic-ipconfig1"
          private_ip_subnet_resource_id = module.virtual_network.subnets["virtual_machines"].resource_id
        }
      }
    }
  }

  tags  = var.tags
  count = var.jumpbox.create ? 1 : 0
}