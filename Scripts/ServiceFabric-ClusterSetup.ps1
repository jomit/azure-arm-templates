# Create Self Signed Certificate
Login-AzureRmAccount

$certificatePath = "C:\MyApps\ServiceFabricLab"
$certificateName = "sflabcertificate1"
$certificatePassword = "pass@Word1"
$certificateDNSName = "jomitsflab"

$keyvaultRGName = "AllVaults"
$keyvaultName = "sflabvalut"

$subscriptionId = "d0c802cd-23ce-4323-a183-5f6d9a84743e"


#Remove-Module ServiceFabricRPHelpers
#git clone https://github.com/ChackDan/Service-Fabric.git
Import-Module C:\github\Service-Fabric\Scripts\ServiceFabricRPHelpers\ServiceFabricRPHelpers.psm1

Invoke-AddCertToKeyVault -SubscriptionId $subscriptionId -ResourceGroupName $keyvaultRGName -Location westus -VaultName $keyvaultName -CertificateName $certificateName -Password $certificatePassword -CreateSelfSignedCertificate -DnsName $certificateDNSName -OutputPath $certificatePath

#Name  : CertificateThumbprint
#Value : A4B19DDF2A23965F1A841B253CDD1052E8EC94B5

#Name  : SourceVault
#Value : /subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/AllVaults/providers/Microsoft.KeyVault/vaults/sflabvault

#Name  : CertificateURL
#Value : https://sflabvault.vault.azure.net:443/secrets/sflabcertificate1/82f31c1d0d644300b11db6a8e682abf7

Import-PfxCertificate -Exportable -CertStoreLocation Cert:\CurrentUser\TrustedPeople -FilePath "$certificatePath\$certificateName.pfx" -Password (Read-Host -AsSecureString -Prompt "Enter Certificate Password ")
Import-PfxCertificate -Exportable -CertStoreLocation Cert:\CurrentUser\My -FilePath "$certificatePath\$certificateName.pfx" -Password (Read-Host -AsSecureString -Prompt "Enter Certificate Password ")


##-----------------------------------------------------------------------------------------------------------


#& "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\ClusterSetup\DevClusterSetup.ps1"

#Import-Module "$ENV:ProgramFiles\Microsoft SDKs\Service Fabric\Tools\PSModule\ServiceFabricSDK\ServiceFabricSDK.psm1"

#-- Reset local cluster
cd "C:\Program Files\Microsoft SDKs\Service Fabric\ClusterSetup\"
#.\DevClusterSetup.ps1 -AsSecureCluster  #create a secure cluster
.\DevClusterSetup.ps1

Connect-ServiceFabricCluster

Publish-NewServiceFabricApplication -ApplicationPackagePath C:\MyApps\ServiceFabricTest\WordCountV1.sfpkg -ApplicationName "fabric:/WordCount"

Get-ServiceFabricApplication

Get-ServiceFabricService -ApplicationName "fabric:/WordCount"

Get-ServiceFabricPartition "fabric:/WordCount/WordCountService"

Publish-UpgradedServiceFabricApplication -ApplicationPackagePath C:\MyApps\ServiceFabricTest\WordCountV2.sfpkg -ApplicationName "fabric:/WordCount" -UpgradeParameters @{"FailureAction"="Rollback"; "UpgradeReplicaSetCheckTimeout"=1; "Monitored"=$true; "Force"=$true}

New-ServiceFabricService -ApplicationName "fabric:/WebApplication" -ServiceName "fabric:/WebApplication/JackService" -ServiceTypeName "JackServiceType" -Stateless -PartitionSchemeSingleton -InstanceCount -1


#-- Stop Nodes in Azure
Add-AzureRmAccount

Set-AzureRmContext -SubscriptionName 'Microsoft Azure Internal Consumption'

Connect-ServiceFabricCluster -ConnectionEndpoint "azbeat.westus.cloudapp.azure.com:19000"

Get-ServiceFabricNode

Get-ServiceFabricNode | Where-Object {$_.NodeName -like "*frontend*"} | Start-ServiceFabricNode -NodeName {$_.NodeName} -CommandCompletionMode DoNotVerify
Get-ServiceFabricNode | Where-Object {$_.NodeName -like "*backend*"} | Start-ServiceFabricNode -NodeName {$_.NodeName} -CommandCompletionMode DoNotVerify

Get-ServiceFabricNode | Stop-ServiceFabricNode -NodeName {$_.NodeName} -CommandCompletionMode DoNotVerify

Get-ServiceFabricNode | Start-ServiceFabricNode -NodeName {$_.NodeName} -CommandCompletionMode DoNotVerify





