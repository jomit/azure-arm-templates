#Add-AzureRmAccount

#Select-AzureRmSubscription -SubscriptionName "Microsoft Azure Internal Consumption"

#Get-AzureVMAvailableExtension | Where-Object {$_.description -like "*McAfee*" }
Get-AzureVMAvailableExtension | Out-GridView

#$CSName = "jomitwinsrv2016.westus.cloudapp.azure.com"
#$VMName = "WinSrv12016"
#$vm = Get-AzureVM -ServiceName $CSName -Name $VMName
#write-host $vm.VM.ProvisionGuestAgent

#$Agent = Get-AzureVMAvailableExtension -Publisher McAfee.EndpointSecurity -ExtensionName McAfeeEndpointSecurity
#Set-AzureVMExtension -Publisher McAfee.EndpointSecurity –Version $Agent.Version -ExtensionName McAfeeEndpointSecurity -VM $vm | Update-AzureVM

$resourceGroupName= "WinServer2016"
$location= "West US"
$vmName= "WinSrv12016"

Set-AzureRmVMExtension -ResourceGroupName $resourceGroupName -VMName $vmName -Name "McAfeeEndpointSecurity" -Publisher "McAfee.EndpointSecurity" -ExtensionType "McAfeeEndpointSecurity" -TypeHandlerVersion "6.0" -Location $location

