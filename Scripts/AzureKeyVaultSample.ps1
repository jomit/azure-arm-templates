#Add-AzureRmAccount
#Select-AzureRmSubscription -SubscriptionName "Microsoft Azure Internal Consumption"
#New-AzureRmResourceGroup –Name 'AllVaults' –Location 'West US'

New-AzureRmKeyVault -VaultName 'KeyVault' -ResourceGroupName 'AllVaults' -Location 'West US'

#### Vault URI : https://KeyVault.vault.azure.net/.

$secretvalue = ConvertTo-SecureString '<password>' -AsPlainText -Force

$key = Set-AzureKeyVaultSecret -VaultName 'KeyVault' -Name 'FTPPassword' -SecretValue $secretvalue

$key.Id

Get-AzureKeyVaultSecret –VaultName 'KeyVault'

Set-AzureRmKeyVaultAccessPolicy -VaultName 'KeyVault' -ServicePrincipalName dc58892c-07c3-4b71-a130-2b872477aa5a -PermissionsToSecrets all