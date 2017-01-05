Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName "Jomit's Internal Subscription"

# Individual VM's
# ----------------------------------------

$rg = "RHELTrials"
$vm = "rhelvm"

#Start-AzureRmVM -ResourceGroupName $rg -Name $vm
Stop-AzureRmVM -ResourceGroupName $rg -Name $vm


# All VM's in a Resource Group
# ----------------------------------------

$resourceGroup = "SchoolsFirstSF"
Get-AzureRmVM -ResourceGroupName $resourceGroup | ForEach-Object { 
    Stop-AzureRmVM -ResourceGroupName $resourceGroup -Name $_.Name -Force -ErrorAction SilentlyContinue
}

Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup | ForEach-Object {
    Remove-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $_.StorageAccountName -ErrorAction SilentlyContinue
}

Get-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup| ForEach-Object {
    Remove-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup -Name $_.Name
}