
azure login
azure vm list
azure config mode arm

$resourceGroupName = 'DiskEncryptionTrials'
$location = 'West US 2'

#--- Create Resource Group

azure group create $resourceGroupName -l $location
azure group show $resourceGroupName --json


#--- Create Storage Account
$storageAcc = 'diskenclinuxvhdstore'
azure storage account create -g $resourceGroupName -l $location --kind Storage --sku-name LRS $storageAcc

azure storage account show -g $resourceGroupName $storageAcc --json 


#--- Create VNET

$vnetName = 'diskencLinuxVnet'
azure network vnet create -g $resourceGroupName -n $vnetName -a 192.168.0.0/16 -l $location
azure network vnet subnet create -g $resourceGroupName -e $vnetName -n FrontEnd -a 192.168.1.0/24
azure network vnet show $resourceGroupName $vnetName --json


#--- Create Public IP and Load Balancer

$loadBalancerName = 'jomitlb'
$publicIP = 'diskencLinuxPIP'
$frontendIPPool = 'diskencLinuxFEPool'
$backendIPPool = 'diskencLinuxBEPool'

azure network public-ip create -g $resourceGroupName -n $publicIP -l $location -d $loadBalancerName -a static -i 4

azure network lb create -g $resourceGroupName -n $loadBalancerName -l $location
azure network lb frontend-ip create -g $resourceGroupName -l $loadBalancerName -n $frontendIPPool -i $publicIP
azure network lb address-pool create -g $resourceGroupName -l $loadBalancerName -n $backendIPPool

azure network lb inbound-nat-rule create -g $resourceGroupName -l $loadBalancerName -n VM1-SSH -p tcp -f 4222 -b 22
azure network lb inbound-nat-rule create -g $resourceGroupName -l $loadBalancerName -n VM2-SSH -p tcp -f 4223 -b 22

azure network lb rule create -g $resourceGroupName -l $loadBalancerName -n WebRule -p tcp -f 80 -b 80 -t $frontendIPPool -o $backendIPPool
azure network lb probe create -g $resourceGroupName -l $loadBalancerName -n HealthProbe -p "http" -f healthprobe.aspx -i 15 -c 

azure network lb show -g $resourceGroupName -n $loadBalancerName --json


#--- Create NIC
$nic1 = 'LB-NICVM1'
$nic2 = 'LB-NICVM2'

azure network nic create -g $resourceGroupName -n $nic1 -l $location --subnet-vnet-name $vnetName --subnet-name FrontEnd `
    -d "/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.Network/loadBalancers/jomitlb/backendAddressPools/diskencLinuxBEPool" `
    -e "/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.Network/loadBalancers/jomitlb/inboundNatRules/VM1-SSH"

azure network nic create -g $resourceGroupName -n $nic2 -l $location --subnet-vnet-name $vnetName --subnet-name FrontEnd `
    -d "/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.Network/loadBalancers/jomitlb/backendAddressPools/diskencLinuxBEPool" `
    -e "/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.Network/loadBalancers/jomitlb/inboundNatRules/VM2-SSH"

azure network nic show $resourceGroupName $nic1 --json
azure network nic show $resourceGroupName $nic2 --json


#--- Create NEtwork Security Groups

$nsgName = 'disklinuxNSG'
azure network nsg create -g $resourceGroupName -n $nsgName -l $location

azure network nsg rule create --protocol tcp --direction inbound --priority 1000 `
    --destination-port-range 22 --access allow $resourceGroupName $nsgName SSHRule


azure network nsg rule create --protocol tcp --direction inbound --priority 1001 `
    --destination-port-range 80 --access allow -g $resourceGroupName $nsgName -n HTTPRule

azure network nic set -g $resourceGroupName -n $nic1 -o $nsgName
azure network nic set -g $resourceGroupName -n $nic2 -o $nsgName



#--- Create Availability Set

$availSetName = 'DiskEncAvailSet'

azure availset create -g $resourceGroupName -n $availSetName -l $location


#--- Create VM's

## Run this in bash to generate the SSH RSA key
## ssh-keygen -t rsa -b 2048

azure vm create `
    --resource-group $resourceGroupName `
    --name linuxVM1 `
    --location $location `
    --os-type linux `
    --availset-name $availSetName `
    --nic-name $nic1 `
    --vnet-name $vnetName `
    --vnet-subnet-name FrontEnd `
    --storage-account-name $storageAcc `
    --image-urn canonical:UbuntuServer:14.04.4-LTS:latest `
    --ssh-publickey-file /users/jovagh/.ssh/id_rsa.pub `
    --admin-username jomit `
    --vm-size Standard_DS1_v2

ssh jomit@jomitlb.westus2.cloudapp.azure.com -p 4222

azure vm create `
    --resource-group $resourceGroupName `
    --name linuxVM2 `
    --location $location `
    --os-type linux `
    --availset-name $availSetName `
    --nic-name $nic2 `
    --vnet-name $vnetName `
    --vnet-subnet-name FrontEnd `
    --storage-account-name $storageAcc `
    --image-urn canonical:UbuntuServer:14.04.4-LTS:latest `
    --ssh-publickey-file /users/jovagh/.ssh/id_rsa.pub  `
    --admin-username jomit `
    --vm-size Standard_DS1_v2



#--- Create KeyVault

#azure vm show-disk-encryption-status --resource-group $resourceGroupName --name linuxVM1 --json 

$keyvaultName = 'JomitLinuxKeyVault'

azure keyvault create --vault-name $keyvaultName --resource-group $resourceGroupName --location $location
azure keyvault set-policy --vault-name $keyvaultName --enabled-for-disk-encryption true

# https://jomitlinuxkeyvault.vault.azure.net/
# /subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.KeyVault/vaults/JomitLinuxKeyVault


# http://jomit-testkeyvault
# client id : dc58892c-07c3-4b71-a130-2b872477aa5a
# client secret : JrEP9SE3ge+tREvADDq0oWs1b+YlcKUCkgIpsaMxEUA=
azure keyvault set-policy --vault-name $keyvaultName --spn dc58892c-07c3-4b71-a130-2b872477aa5a --perms-to-keys '[\"all\"]' --perms-to-secrets '[\"all\"]'


azure vm enable-disk-encryption --resource-group $resourceGroupName --name linuxVM1 `
    --aad-client-id dc58892c-07c3-4b71-a130-2b872477aa5a `
    --aad-client-secret JrEP9SE3ge+tREvADDq0oWs1b+YlcKUCkgIpsaMxEUA= `
    --disk-encryption-key-vault-url https://jomitlinuxkeyvault.vault.azure.net/ `
    --disk-encryption-key-vault-id /subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/DiskEncryptionTrials/providers/Microsoft.KeyVault/vaults/JomitLinuxKeyVault


