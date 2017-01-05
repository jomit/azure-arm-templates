#Add-AzureAccount
#Select-AzureSubscription -SubscriptionName "Microsoft Azure Internal Consumption"
#Select-AzureRmSubscription -SubscriptionName "Visual Studio Enterprise"

<#

.NAME
       Get-SubscriptionLimit
       
.SYNOPSIS 
    Retrieves Soft limits for some azure resources

.DESCRIPTION
       
       This retrieves soft limits for the following azure resouces
        1. Affinity Group
        2. Cloud Service
        3. Co-Administrators
        4. Cores
        5. DNS Servers
        6. Storage Accounts
        7. VLAN
        8. VM
        9. VNET
       
    Requirements: 
        NONE

.PARAMETER SCOPE
    Scope Option
        AFFINITYGROUP - Affinity Group Soft Limit
        CLOUDSERVICE - Cloud Service Soft Limit
        CLOUDSERVICEDETAIL - Cloud Sercice Detailed. 
        CO-ADMIN - Co-Administrators Soft Limit
        CORE-LIMIT - Core Soft Limit
        DNS-SERVERS - DNS Server Soft Limit
        STORAGEACCOUNT - Storage Account Soft Limit
        VLAN - VLAN Soft Limit
        VM - VM Soft Limit
        VNET - VNET Soft Limit
        ALL - ALL Soft Limit resources mentioned above
       
.EXAMPLE
    Get-Subscriptionlimit -SCOPE AFFINITYGROUP
    Get-Subscriptionlimit -SCOPE ALL

.NOTES
    AUTHOR: Microsoft Services
    LASTEDIT: July 22, 2015
#>

#Set Parameter
param(
             [parameter(Mandatory=$true)][String]$SCOPE
       )
if($SCOPE -ne "CLOUDSERVICEDETAIL"){

Write-Host "`nResource           PercentageUsed(%)  CurrentUse  Max Limit"
write-Host "--------           ----------------   ----------  ---------"
}

switch($SCOPE)
{
{($SCOPE -eq "AFFINITYGROUP") -or ($SCOPE -eq "ALL")}
{
        $getAF = Get-AzureAffinityGroup
        $currentAF = $getAF.Count
        $maxAF = 256
        $value = ($currentAF/$maxAF)*100
        $percentage = ($currentAF/$maxAF).ToString("P")

        if($currentAF -eq 0)
        {
        Write-Host "AffinityGroup".PadRight(18) "$percentage".PadRight(18) "$currentAF".PadRight(11) $maxAF -ForegroundColor Green
        }
        elseif($value -le 74)
            {
            Write-Host "AffinityGroup".PadRight(18) "$percentage".PadRight(18) "$currentAF".PadRight(11) $maxAF -ForegroundColor Green
            }
            elseif(($value -ge 75) -and ($percentage -le 89))
                { 
                Write-Host "AffinityGroup".PadRight(18) "$percentage".PadRight(18) "$currentAF".PadRight(11) $maxAF -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "AffinityGroup".PadRight(18) "$percentage".PadRight(18) "$currentAF".PadRight(11) $maxAF -ForegroundColor Red
                }

 }
{($SCOPE -eq "CLOUDSERVICE") -or ($SCOPE -eq "ALL")}
{
         $maxHostedServices     = (Get-AzureSubscription -current -ExtendedDetails).maxHostedServices

         $curHS = (Get-AzureSubscription -current -ExtendedDetails).currentHostedServices
         $value = ($curHS/$maxHostedServices)*100
         $percentage = ($curHS/$maxHostedServices).ToString("P")

         if($currentHostedServices -eq 0)
            {
            Write-Host "CloudService".PadRight(18) "$percentage".PadRight(18) "$curHS".PadRight(11) $maxHostedServices -ForegroundColor Green
            }
            elseif($value -le 74)
                {
                Write-Host "CloudService".PadRight(18) "$percentage".PadRight(18) "$curHS".PadRight(11) $maxHostedServices -ForegroundColor Green
                }
                elseif(($value -ge 75) -and ($value -le 89))
                {
                Write-Host "CloudService".PadRight(18) "$percentage".PadRight(18) "$curHS".PadRight(11) $maxHostedServices -ForegroundColor Yellow
                }
                elseif($value -ge 90)
                    {
                    Write-Host "CloudService".PadRight(18) "$percentage".PadRight(18) "$curHS".PadRight(11) $maxHostedServices -ForegroundColor Red
                    }
                               
 }  
{($SCOPE -eq "CO-ADMIN") -or ($SCOPE -eq "ALL")}
{
    try{
         $subname = (Get-AzureSubscription -Current).SubscriptionName
         $sub = Get-AzureSubscription  $subname
         $maxCoAdmin = 200

         # API method

         $method = "GET"

         # API header

         $headerDate = '2013-08-01'

         $headers = @{"x-ms-version"="$headerDate"}

         # generate the API URI

         $subID = $sub.SubscriptionId

         $URI = "https://management.core.windows.net/$subID/principals"

         # grab the Azure management certificate
         $subcert = (Get-ChildItem Cert:\CurrentUser\My | ?{$_.FriendlyName -match "^$subname"})

         $mgmtCertThumb = $subcert.Thumbprint

         # execute the Azure REST API
         $principalNUMArray = @()
         $list = Invoke-RestMethod -Uri $URI -Method $method -Headers $headers -CertificateThumbprint $mgmtCertThumb 
            foreach( $Principal in $list.Principals.Principal) 
                { 
                $PrincipalNum = $Principal.Email
                    if($principal.Role -eq "CoAdministrator")
                    {
                    $principalNUMArray += $PrincipalNum
                    }
   
                }
         $currentCoAdmin = $principalNUMArray.Count
         $percentage = ($currentCoAdmin/$maxCoAdmin).ToString("P")
         $value = ($currentCoAdmin/$maxCoAdmin)*100

            if($currentCoAdmin -eq 0)
            {
            Write-Host "Co-Admin".PadRight(18) "$percentage".PadRight(18) "$currentCoAdmin".PadRight(11) $maxCoAdmin -ForegroundColor Green
            }
                elseif($value -le 74)
                { 
                Write-Host "Co-Admin".PadRight(18) "$percentage".PadRight(18) "$currentCoAdmin".PadRight(11) $maxCoAdmin -ForegroundColor Green
                }
                    elseif(($value -ge 75) -and ($percentage -le 89))
                    {
                    Write-Host "Co-Admin".PadRight(18) "$percentage".PadRight(18) "$currentCoAdmin".PadRight(11) $maxCoAdmin -ForegroundColor Yellow
                    }
                    elseif($value -ge 90)
                    {
                    Write-Host "Co-Admin".PadRight(18) "$percentage".PadRight(18) "$currentCoAdmin".PadRight(11) $maxCoAdmin -ForegroundColor Red
                    }

        }

        catch{
            #Nothing to see here, move on
        }
}
{($SCOPE -eq "CORE-LIMIT") -or ($SCOPE -eq "ALL")}
{
        $maxVMCores     = (Get-AzureSubscription -current -ExtendedDetails).maxcorecount

        $currentVMCores = (Get-AzureSubscription -current -ExtendedDetails).currentcorecount

        $percentage = ($currentVMCores/$maxVMCores).ToString("P")
        $value = ($currentVMCores/$maxVMCores)*100

            if($currentVMCores -eq 0)
            {
            Write-Host "Cores".PadRight(18) "$percentage".PadRight(18) "$currentVMCores".PadRight(11) $maxVMCores -ForegroundColor Green
            }
                elseif($value -le 74)
                    {
                    Write-Host "Cores".PadRight(18) "$percentage".PadRight(18) "$currentVMCores".PadRight(11) $maxVMCores -ForegroundColor Green
                    }
                elseif(($value -ge 75) -and ($percentage -le 89))
                    {
                    Write-Host "Cores".PadRight(18) "$percentage".PadRight(18) "$currentVMCores".PadRight(11) $maxVMCores -ForegroundColor Yellow
                    }
                elseif($value -ge 90)
                    {
                    Write-Host "Cores".PadRight(18) "$percentage".PadRight(18) "$currentVMCores".PadRight(11) $maxVMCores -ForegroundColor Red
                    }


}
{($SCOPE -eq "DNS-SERVERS") -or ($SCOPE -eq "ALL")}
{
        $maxDNSServers     = (Get-AzureSubscription -current -ExtendedDetails).maxDnsServers

        $currentDNSServers = (Get-AzureSubscription -current -ExtendedDetails).currentDnsServers

        $percentage = ($currentDNSServers/$maxDNSServers).ToString("P")
        $value = ($currentDNSServers/$maxDNSServers)*100

        if($currentDNSServers -eq 0)
        {
        Write-Host "DNS-Servers".PadRight(18) "$percentage".PadRight(18) "$currentDNSServers".PadRight(11) $maxDNSServers -ForegroundColor Green
        }
            elseif($value -le 74)
                {
                Write-Host "DNS-Servers".PadRight(18) "$percentage".PadRight(18) "$currentDNSServers".PadRight(11) $maxDNSServers -ForegroundColor Green
                }
            elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "DNS-Servers".PadRight(18) "$percentage".PadRight(18) "$currentDNSServers".PadRight(11) $maxDNSServers -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "DNS-Servers".PadRight(18) "$percentage".PadRight(18) "$currentDNSServers".PadRight(11) $maxDNSServers -ForegroundColor Red
                }
                
                                          
}
{($SCOPE -eq "STORAGEACCOUNT") -or ($SCOPE -eq "ALL")}
{
        $maxStorageAccounts     = (Get-AzureSubscription -current -ExtendedDetails).maxStorageAccounts

        $currentStorageAccounts = (Get-AzureSubscription -current -ExtendedDetails).currentStorageAccounts

        $percentage = ($currentStorageAccounts/$maxStorageAccounts).ToString("P")
        $value = ($currentStorageAccounts/$maxStorageAccounts)*100

        if($currentStorageAccounts -eq 0)
        {
        Write-Host "Storage Accounts".PadRight(18) "$percentage".PadRight(18) "$currentStorageAccounts".PadRight(11) $maxStorageAccounts -ForegroundColor Green
        }
        elseif($value -le 74)
            {
            Write-Host "Storage Accounts".PadRight(18) "$percentage".PadRight(18) "$currentStorageAccounts".PadRight(11) $maxStorageAccounts -ForegroundColor Green
            }
            elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "Storage Accounts".PadRight(18) "$percentage".PadRight(18) "$currentStorageAccounts".PadRight(11) $maxStorageAccounts -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "Storage Accounts".PadRight(18) "$percentage".PadRight(18) "$currentStorageAccounts".PadRight(11) $maxStorageAccounts -ForegroundColor Red
                }


}
{($SCOPE -eq "VLAN") -or ($SCOPE -eq "ALL")}
{
        $maxVLAN     = (Get-AzureSubscription -current -ExtendedDetails).maxLocalNetworkSites
        $currentVLAN = (Get-AzureSubscription -current -ExtendedDetails).currentLocalNetworkSites
        $percentage = ($currentVLAN/$maxVLAN).ToString("P")
        $value = ($currentVLAN/$maxVLAN)*100

        if($currentVLAN -eq 0)
        {
        Write-Host "VLAN".PadRight(18) "$percentage".PadRight(18) "$currentVLAN".PadRight(11) $maxVLAN -ForegroundColor Green
        }
        elseif($value -le 74)
            {
            Write-Host "VLAN".PadRight(18) "$percentage".PadRight(18) "$currentVLAN".PadRight(11) $maxVLAN -ForegroundColor Green
            }
            elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "VLAN".PadRight(18) "$percentage".PadRight(18) "$currentVLAN".PadRight(11) $maxVLAN -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "VLAN".PadRight(18) "$percentage".PadRight(18) "$currentVLAN".PadRight(11) $maxVLAN -ForegroundColor Red
                }


}
{($SCOPE -eq "VM") -or ($SCOPE -eq "ALL")}
{
        $maxCloudServices = (Get-AzureSubscription -current -ExtendedDetails).maxhostedservices
        $maxVMs = $maxCloudServices * 50
        $Azurevm = Get-AzureVM
        $Azurevmcount = $Azurevm.Count
        $percentage = ($Azurevm.Count/$maxVMs ).ToString("P")
        $value = ($Azurevm.Count/$maxVMs )*100

        if($Azurevmcount -eq 0)
        {
        Write-Host "VM".PadRight(18) "$percentage".PadRight(18) "$Azurevmcount".PadRight(11) $maxVMs -ForegroundColor Green
        }
        elseif($value -le 74)
            {
            Write-Host "VM".PadRight(18) "$percentage".PadRight(18) "$Azurevmcount".PadRight(11) $maxVMs -ForegroundColor Green
            }
            elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "VM".PadRight(18) "$percentage".PadRight(18) "$Azurevmcount".PadRight(11) $maxVMs -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "VM".PadRight(18) "$percentage".PadRight(18) "$Azurevmcount".PadRight(11) $maxVMs -ForegroundColor Red
                }

}
{($SCOPE -eq "VNET") -or ($SCOPE -eq "ALL")}
{
        $maxVNET     = (Get-AzureSubscription -current -ExtendedDetails).maxVirtualNetworkSites
        $currentVNET = (Get-AzureSubscription -current -ExtendedDetails).currentVirtualNetworkSites
        $percentage = ($currentVNET/$maxVNET).ToString("P")
        $value = ($currentVNET/$maxVNET)*100

        if($currentVNET -eq 0)
        {
        Write-Host "VNET".PadRight(18) "$percentage".PadRight(18) "$currentVNET".PadRight(11) $maxVNET -ForegroundColor Green
        }
        elseif($value -le 74)
            {
            Write-Host "VNET".PadRight(18) "$percentage".PadRight(18) "$currentVNET".PadRight(11) $maxVNET -ForegroundColor Green
            }
            elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "VNET".PadRight(18) "$percentage".PadRight(18) "$currentVNET".PadRight(11) $maxVNET -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "VNET".PadRight(18) "$percentage".PadRight(18) "$currentVNET".PadRight(11) $maxVNET -ForegroundColor Red
                }


}
{($SCOPE -eq "CLOUDSERVICEDETAIL") -or ($SCOPE -eq "ALL")}
{

Write-Host "`nBelow are Cloud Services Limit in Detail`n"
Write-Host "CS Name            PercentageUsed(%)  CurrentUse  Max Limit"
write-Host "--------           ----------------   ----------  ---------"

        $cloudService = @((Get-AzureService).ServiceName)
        $cloudServiceCount = $cloudService.Count

        foreach($cloudServiceItem in $cloudService)
        {
            $VMs = @((Get-AzureVM -ServiceName $cloudServiceItem -WarningAction SilentlyContinue).InstanceName)
            if($VMs)
            {
                $vmCount = $VMs.Count
            }
            else
            {
                $vmCount = 0
            }

            $percentage = ($vmCount/50).ToString("P")
            $value = ($vmCount/50)*100

            if($cloudServiceItem.Length -ge 17){
            $cloudServiceItem = $cloudServiceItem.substring(0,17)
            }
                  
         if($vmCount -eq 0)
            {
            Write-Host "$cloudServiceItem".PadRight(18) "$percentage".PadRight(18) "$vmCount".PadRight(11) "50" -ForegroundColor Green
            }
            elseif($value -le 74)
                {
                Write-Host "$cloudServiceItem".PadRight(18) "$percentage".PadRight(18) "$vmCount".PadRight(11) "50" -ForegroundColor Green
                }
                elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "$cloudServiceItem".PadRight(18) "$percentage".PadRight(18) "$vmCount".PadRight(11) "50" -ForegroundColor Yellow
                }
                elseif($value -ge 90)
                    {
                    Write-Host "$cloudServiceItem".PadRight(18) "$percentage".PadRight(18) "$vmCount".PadRight(11) "50" -ForegroundColor Red
                    }
                             
                  $vmCount = $null
        }
           
 }
}
