Add-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName "Jomit's Internal Subscription"

$resourceGroupName = 'AllVaults'
$location = 'West US'
$vaultName = 'linuxvmvault'

New-AzureRmKeyVault -VaultName $vaultName -ResourceGroupName $resourceGroupName -Location $location
#### Vault URI : https://linuxvmvault.vault.azure.net/

$aadAppName = 'jomitdiskencryptapp'

C:\MyApps\Scripts\DiskEncryptionPrereqScript.ps1 $resourceGroupName $vaultName $location $aadAppName

# aadClientID: b6df940f-a8d4-40d2-a70e-50e1487b23a5
# aadClientSecret: 5a00a199-dfee-474c-8bca-edafad2cb10d
# diskEncryptionKeyVaultUrl: https://linuxvmvault.vault.azure.net/
# keyVaultResourceId: /subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/AllVaults/providers/Microsoft.KeyVault/vaults/linuxvmvault

$vmResourceGroupName = "RHELTrials"
$vmName = "rhelvm"
$aadClientID = "b6df940f-a8d4-40d2-a70e-50e1487b23a5"
$aadClientSecret = "5a00a199-dfee-474c-8bca-edafad2cb10d"
$diskEncryptionKeyVaultUrl = "https://linuxvmvault.vault.azure.net/"
$keyVaultResourceId = "/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/AllVaults/providers/Microsoft.KeyVault/vaults/linuxvmvault"

#--------------------------------------------------------------------------------------------------------------------------------
# ARM Template : https://azure.microsoft.com/en-us/documentation/templates/201-encrypt-running-linux-vm/
#--------------------------------------------------------------------------------------------------------------------------------
New-AzureRmResourceGroupDeployment -Name jomitdiskencryptdeploy `
-ResourceGroupName $vmResourceGroupName `
-TemplateUri https://raw.githubusercontent.com/azure/azure-quickstart-templates/master/201-encrypt-running-linux-vm/azuredeploy.json `
-TemplateParameterFile C:\MyApps\Scripts\DiskEncryptionLinuxParameters.json


#-----------------------------------------------------------------------------------
#  Enabling encryption is only allowed on Data volumes for Linux VMs.
#-----------------------------------------------------------------------------------
 
# Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $vmResourceGroupName -VMName $vmName `
# -AadClientID $aadClientID -AadClientSecret $aadClientSecret `
# -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $keyVaultResourceId