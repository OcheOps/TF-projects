resource "azurerm_public_ip" "azure_vpn_gw_pip1" {
  name                = "azure-vpn-gateway-pip1"
  location            = azurerm_resource_group.vpn_rg.location
  resource_group_name = azurerm_resource_group.vpn_rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_public_ip" "azure_vpn_gw_pip2" {
  name                = "azure-vpn-gateway-pip2"
  location            = azurerm_resource_group.vpn_rg.location
  resource_group_name = azurerm_resource_group.vpn_rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_virtual_network_gateway" "azure_vpn_gw" {
  name                = "azure-vpn-gateway"
  location            = azurerm_resource_group.vpn_rg.location
  resource_group_name = azurerm_resource_group.vpn_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig1"
    public_ip_address_id          = azurerm_public_ip.azure_vpn_gw_pip1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.azure_vpn_gw_pip2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}