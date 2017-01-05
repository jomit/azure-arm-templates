##----------------------------------------------------------------------------
## Part 3 - Establish a VNet-to-VNet connection with BGP

# 1. Declare your variables

$RG2           = "TestingBGP-2"
$Location2     = "East US"
$VNetName2     = "TestVNet2"
$FESubName2    = "FrontEnd"
$BESubName2    = "Backend"
$GWSubName2    = "GatewaySubnet"
$VNetPrefix21  = "10.21.0.0/16"
$VNetPrefix22  = "10.22.0.0/16"
$FESubPrefix2  = "10.21.0.0/24"
$BESubPrefix2  = "10.22.0.0/24"
$GWSubPrefix2  = "10.22.255.0/27"
$VNet2ASN      = 65020
$DNS2          = "8.8.8.8"
$GWName2       = "VNet2GW"
$GWIPName2     = "VNet2GWIP"
$GWIPconfName2 = "gwipconf2"
$Connection21  = "VNet2toVNet1"
$Connection12  = "VNet1toVNet2"

# 2. Create TestVNet2 in the new resource group

New-AzureRmResourceGroup -Name $RG2 -Location $Location2

$fesub2 = New-AzureRmVirtualNetworkSubnetConfig -Name $FESubName2 -AddressPrefix $FESubPrefix2
$besub2 = New-AzureRmVirtualNetworkSubnetConfig -Name $BESubName2 -AddressPrefix $BESubPrefix2
$gwsub2 = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubName2 -AddressPrefix $GWSubPrefix2

New-AzureRmVirtualNetwork -Name $VNetName2 -ResourceGroupName $RG2 -Location $Location2 -AddressPrefix $VNetPrefix21,$VNetPrefix22 -Subnet $fesub2,$besub2,$gwsub2


# 3. Create the VPN gateway for TestVNet2 with BGP parameters

$gwpip2    = New-AzureRmPublicIpAddress -Name $GWIPName2 -ResourceGroupName $RG2 -Location $Location2 -AllocationMethod Dynamic

$vnet2     = Get-AzureRmVirtualNetwork -Name $VNetName2 -ResourceGroupName $RG2
$subnet2   = Get-AzureRmVirtualNetworkSubnetConfig -Name "GatewaySubnet" -VirtualNetwork $vnet2
$gwipconf2 = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPconfName2 -Subnet $subnet2 -PublicIpAddress $gwpip2

New-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $RG2 -Location $Location2 -IpConfigurations $gwipconf2 -GatewayType Vpn -VpnType RouteBased -GatewaySku Standard -Asn $VNet2ASN


## Step 2 - Connect the TestVNet1 and TestVNet2 gateways

#1. Get both gateways

$RG1           = "TestingBGP"
$GWName1       = "VNet1GW"
$Location1     = "West US"

$vnet1gw = Get-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1
$vnet2gw = Get-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $RG2

# 2. Create both connections

New-AzureRmVirtualNetworkGatewayConnection -Name $Connection12 -ResourceGroupName $RG1 -VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet2gw -Location $Location1 -ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3' -EnableBgp True

New-AzureRmVirtualNetworkGatewayConnection -Name $Connection21 -ResourceGroupName $RG2 -VirtualNetworkGateway1 $vnet2gw -VirtualNetworkGateway2 $vnet1gw -Location $Location2 -ConnectionType Vnet2Vnet -SharedKey 'AzureA1b2C3' -EnableBgp True


