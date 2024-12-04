data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

resource "aws_customer_gateway" "azure_cgw1" {
  bgp_asn    = 65000
  ip_address = azurerm_public_ip.azure_vpn_gw_pip1.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "Azure-VPN-Gateway-1"
  }
}

resource "aws_customer_gateway" "azure_cgw2" {
  bgp_asn    = 65001
  ip_address = azurerm_public_ip.azure_vpn_gw_pip2.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "Azure-VPN-Gateway-2"
  }
}

resource "aws_vpn_gateway" "aws_vgw" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "AWS-VPN-Gateway"
  }
}