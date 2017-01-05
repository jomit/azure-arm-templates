Add-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName "Jomit's Internal Subscription"
$resourceGroupName = 'DiskEncryptionTrials'
$location = 'West US 2'
New-AzureRmResourceGroup –Name $resourceGroupName –Location $location


$vaultName = 'BoeingKeyVault'
New-AzureRmKeyVault -VaultName $vaultName -ResourceGroupName $resourceGroupName -Location $location
#### Vault URI : https://BoeingKeyVault.vault.azure.net/.

$aadAppName = 'diskencryptionTrialApp'
C:\MyApps\Scripts\DiskEncryptionPrereqScript.ps1 $resourceGroupName $vaultName $location $aadAppName


# aadClientID: a5b6278d-1419-42e6-a996-6b31a5286d53
# aadClientSecret: 81535a06-284d-4f2c-b31b-378205c84d0d
# diskEncryptionKeyVaultUrl: https://boeingkeyvault.vault.azure.net/
# keyVaultResourceId: /subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.KeyVault/vaults/BoeingKeyVault

$aadClientID = 'a5b6278d-1419-42e6-a996-6b31a5286d53'
$aadClientSecret = '81535a06-284d-4f2c-b31b-378205c84d0d'
$diskEncryptionKeyVaultUrl = 'https://boeingkeyvault.vault.azure.net/'
$keyVaultResourceId = '/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.KeyVault/vaults/BoeingKeyVault'


Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $resourceGroupName -VMName $vmName `
-AadClientID $aadClientID -AadClientSecret $aadClientSecret `
-DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $keyVaultResourceId