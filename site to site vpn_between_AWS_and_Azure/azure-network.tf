resource "azurerm_resource_group" "vpn_rg" {
  name     = "site-to-site-vpn-rg"
  location = var.azure_location
}

resource "azurerm_virtual_network" "azure_vnet" {
  name                = "azure-vpn-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vpn_rg.location
  resource_group_name = azurerm_resource_group.vpn_rg.name
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vpn_rg.name
  virtual_network_name = azurerm_virtual_network.azure_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}