Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName "Jomit's Internal Subscription"

#--- Create Resource Group
Get-AzureRmLocation | sort Location | Select Location
$resourceGroupName = 'DiskEncryptionTrials'
$location = 'West US 2'

New-AzureRmResourceGroup –Name $resourceGroupName –Location $location


#--- Create Storage Account

$storageAcName = "diskencryptionvhdstorage"
Get-AzureRmStorageAccountNameAvailability $storageAcName

$storageAcc = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAcName -SkuName "Standard_LRS" -Kind "Storage" -Location $location

#--- Create VNET

$subnetName = "FrontEnd"
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24

$vnetName = "DiskEncryptionTrialVNET"
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet


#--- Create Public IP and NIC

$ipName = "diskencPublicIP"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic


$nicName = "diskencNIC"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id


#--- Create Virtual Machine

$cred = Get-Credential -Message "Type the name and password of the local administrator account."

$vmName = "diskencVM"
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize "Standard_DS1_v2"

$compName = "diskencVM"
$vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $compName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"

$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id


$blobPath = "vhds/WindowsVMosDisk.vhd"
$osDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $blobPath

$diskName = "windowsvmosdisk"
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage

New-AzureRmVM -ResourceGroupName $resourceGroupName -Location $location -VM $vm