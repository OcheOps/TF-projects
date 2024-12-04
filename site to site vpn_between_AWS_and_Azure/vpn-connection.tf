resource "aws_vpn_connection" "azure_vpn_connection1" {
  vpn_gateway_id      = aws_vpn_gateway.aws_vgw.id
  customer_gateway_id = aws_customer_gateway.azure_cgw1.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "AWS-Azure-VPN-Connection-1"
  }
}

resource "aws_vpn_connection" "azure_vpn_connection2" {
  vpn_gateway_id      = aws_vpn_gateway.aws_vgw.id
  customer_gateway_id = aws_customer_gateway.azure_cgw2.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "AWS-Azure-VPN-Connection-2"
  }
}

# Optional: Add static routes
resource "aws_vpn_connection_route" "azure_route1" {
  destination_cidr_block = "10.0.0.0/16"
  vpn_connection_id      = aws_vpn_connection.azure_vpn_connection1.id
}

resource "aws_vpn_connection_route" "azure_route2" {
  destination_cidr_block = "10.0.0.0/16"
  vpn_connection_id      = aws_vpn_connection.azure_vpn_connection2.id
}
