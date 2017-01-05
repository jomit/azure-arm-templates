#Add-AzureRmAccount
##Get-AzureRmSubscription
#Select-AzureRmSubscription -SubscriptionName "Microsoft Azure Internal Consumption"
#Select-AzureRmSubscription -SubscriptionName "Visual Studio Enterprise"

<#

.NAME
       Get-ARMSubscriptionLimit
       
.SYNOPSIS 
    Retrieves Soft limits for some Azure Resources using ARM Cmdlets.

.DESCRIPTION
       
       This retrieves soft limits for the following azure resouces
        1. Resource Group
        2. Cores
        3. DNS Servers
        4. Storage Accounts
        5. VLAN
        6. VM
        7. VNET
       
    Requirements: 
        NONE

.PARAMETER SCOPE
    Scope Option
        RESOURCEGROUP - Resource Group Soft Limit Per Region
        CORE-LIMIT - Core Soft Limit
        DNS-SERVERS - DNS Server Soft Limit
        STORAGEACCOUNT - Storage Account Soft Limit
        VM - VM Soft Limit
        VNET - VNET Soft Limit
        ALL - ALL Soft Limit resources mentioned above
    
    REGION Option
        NA - North America
        EU - Europe
        ASIA - Asia (Excluding Azure China)
        BRAZIL - Brazil
        JAPAN - Japan
        AU - Australia
        INDIA - India
        USGOV - US Goverment 
        ALL - ALL the Regions Above Except US Gov
        ALL+ - ALL the Regions Above Including US Gov
    
    DETAIL Option
        VMDETAIL - Details on VM Limits Based on Region
        RGDETAIL - Details on RG Limits Based on Region
        ALL - Details for both VMDETAIL & RGDETAIL
       
.EXAMPLE
    Get-ARMSubscriptionlimit -SCOPE RESOURCEGROUP
    Get-ARMSubscriptionlimit -SCOPE ALL

.NOTES
    AUTHOR: Henry Robalino, MCS
    LASTEDIT: Dec 9, 2015
    Version 1.0
#>

#Set Parameter
param(
             [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][String]$SCOPE,
             [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][String]$REGION,
             [parameter(Mandatory=$false)][ValidateNotNullOrEmpty()][String]$DETAIL             
       )

switch($REGION)
{
{($REGION -eq "NA") -or ($REGION -eq "ALL")}
{ 
    $NARegionArray = @("East US","East US 2","North Central US","South Central US","Central US", "West US")
    foreach($regionItem in $NARegionArray)
    {
        $i = 0
        $NAUsage = (Get-AzureRmVMUsage -Location $regionItem)
        $NAUsageAS += $NAUsage.CurrentValue[$i]
        $NAUsageASLimit += $NAUsage.Limit[$i++]
        $NAUsageCores += $NAUsage.CurrentValue[$i]
        $NAUsageCoresLimit += $NAUsage.Limit[$i++]
        $NAUsageVM += $NAUsage.CurrentValue[$i]
        $NAUsageVMLimit += $NAUsage.Limit[$i]
    }
}
{($REGION -eq "EU") -or ($REGION -eq "ALL")}
{
    $EURegionArray = @("West Europe","North Europe")
    foreach($regionItem in $EURegionArray)
    {
        $i = 0
        $EUUsage = (Get-AzureRmVMUsage -Location $regionItem) 
        $EUUsageAS += $EUUsage.CurrentValue[$i]
        $EUUsageASLimit += $EUUsage.Limit[$i++]
        $EUUsageCores += $EUUsage.CurrentValue[$i]
        $EUUsageCoresLimit += $EUUsage.Limit[$i++]
        $EUUsageVM +=  $EUUsage.CurrentValue[$i]
        $EUUsageVMLimit += $EUUsage.Limit[$i]
       
    }
}
{($REGION -eq "USGOV") -or ($REGION -eq "ALL+")}
{
    Write-Verbose "You have chosen US Gov, this will only work if you have access to that Provider."
    $USGOVRegionArray = @("US Gov Virginia","US Gov Iowa")
    foreach($regionItem in $USGOVRegionArray)
    {
        $i = 0
        $USGOVUsage = (Get-AzureRmVMUsage -Location $regionItem -ErrorAction SilentlyContinue)
        $USGOVUsageAS += $USGOVUsage.CurrentValue[$i]
        $USGOVUsageASLimit += $USGOVUsage.Limit[$i++]
        $USGOVUsageCores += $USGOVUsage.CurrentValue[$i]
        $USGOVUsageCoresLimit += $USGOVUsage.Limit[$i++]
        $USGOVUsageVM +=  $USGOVUsage.CurrentValue[$i]
        $USGOVUsageVMLimit += $USGOVUsage.Limit[$i]   
    }
}
{($REGION -eq "ASIA") -or ($REGION -eq "ALL")}
{
    $ASIARegionArray = @("East Asia","Southeast Asia")
    foreach($regionItem in $ASIARegionArray)
    {
        $i = 0
        $ASIAUsage = (Get-AzureRmVMUsage -Location $regionItem)
        $ASIAUsageAS += $ASIAUsage.CurrentValue[$i]
        $ASIAUsageASLimit += $ASIAUsage.Limit[$i++]
        $ASIAUsageCores += $ASIAUsage.CurrentValue[$i]
        $ASIAUsageCoresLimit += $ASIAUsage.Limit[$i++]
        $ASIAUsageVM +=  $ASIAUsage.CurrentValue[$i]
        $ASIAUsageVMLimit += $ASIAUsage.Limit[$i]     
    }
}
{($REGION -eq "BRAZIL") -or ($REGION -eq "ALL")}
{
    $BZRegionArray = @("Brazil South")
    foreach($regionItem in $BZRegionArray)
    {
        $i = 0
        $BRAZILUsage = (Get-AzureRmVMUsage -Location $regionItem)
        $BRAZILUsageAS += $BRAZILUsage.CurrentValue[$i]
        $BRAZILUsageASLimit += $BRAZILUsage.Limit[$i++]
        $BRAZILUsageCores += $BRAZILUsage.CurrentValue[$i]
        $BRAZILUsageCoresLimit += $BRAZILUsage.Limit[$i++]
        $BRAZILUsageVM +=  $BRAZILUsage.CurrentValue[$i]
        $BRAZILUsageVMLimit += $BRAZILUsage.Limit[$i]       
    }
}
{($REGION -eq "JAPAN") -or ($REGION -eq "ALL")}
{
    $JPRegionArray = @("Japan East","Japan West")
    foreach($regionItem in $JPRegionArray)
    {
        $i = 0
        $JAPANUsage = (Get-AzureRmVMUsage -Location $regionItem)
        $JAPANUsageAS += $JAPANUsage.CurrentValue[$i]
        $JAPANUsageASLimit += $JAPANUsage.Limit[$i++]
        $JAPANUsageCores += $JAPANUsage.CurrentValue[$i]
        $JAPANUsageCoresLimit += $JAPANUsage.Limit[$i++]
        $JAPANUsageVM +=  $JAPANUsage.CurrentValue[$i]
        $JAPANUsageVMLimit += $JAPANUsage.Limit[$i]    
    }
}
{($REGION -eq "AU") -or ($REGION -eq "ALL")}
{
    $AURegionArray = @("Australia East","Australia Southeast")
    foreach($regionItem in $AURegionArray)
    {
        $i = 0
        $AUUsage = (Get-AzureRmVMUsage -Location $regionItem)
        $AUUsageAS += $AUUsage.CurrentValue[$i]
        $AUUsageASLimit += $AUUsage.Limit[$i++]
        $AUUsageCores += $AUUsage.CurrentValue[$i]
        $AUUsageCoresLimit += $AUUsage.Limit[$i++]
        $AUUsageVM +=  $AUUsage.CurrentValue[$i]
        $AUUsageVMLimit += $AUUsage.Limit[$i]     
    }
}
{($REGION -eq "INDIA") -or ($REGION -eq "ALL")}
{
    $INDIARegionArray = @("Central India","South India","West India")
    foreach($regionItem in $INDIARegionArray)
    {
        $i = 0
        $INDIAUsage = (Get-AzureRmVMUsage -Location $regionItem)
        $INDIAUsageAS += $INDIAUsage.CurrentValue[$i]
        $INDIAUsageASLimit += $INDIAUsage.Limit[$i++]
        $INDIAUsageCores += $INDIAUsage.CurrentValue[$i]
        $INDIAUsageCoresLimit += $INDIAUsage.Limit[$i++]
        $INDIAUsageVM +=  $INDIAUsage.CurrentValue[$i]
        $INDIAUsageVMLimit += $INDIAUsage.Limit[$i]     
    }
}
}

$RegionsArray = @($NARegionArray,$EURegionArray,$USGOVRegionArray,$ASIARegionArray,$BZRegionArray,$JPRegionArray,$AURegionArray,$INDIARegionArray)

if($REGION -eq "ALL"){
    Write-Host "All the Regions Chosen except for US GOV.`n"
}
elseif($REGION -eq "ALL+"){
    Write-Host "All the Regions Chosen as well as US GOV.`n"
}
else{
    Write-Host "Region Chosen: $REGION"
}

if($SCOPE)
{

Write-Host "`nResource           PercentageUsed(%)  CurrentUse  Max Limit"
write-Host "--------           ----------------   ----------  ---------"
}

#RG Max Value
$maxRG = 800


switch($SCOPE)
{
{($SCOPE -eq "RESOURCEGROUP") -or ($SCOPE -eq "ALL")}
{
        $getRG = Get-AzureRmResourceGroup
        $currentRG = $getRG.Count
        $value = ($currentRG/$maxRG)*100
        $percentage = ($currentRG/$maxRG).ToString("P")

        if($currentRG -eq 0)
        {
        Write-Host "Resource Groups".PadRight(18) "$percentage".PadRight(18) "$currentRG".PadRight(11) $maxRG -ForegroundColor Green
        }
        elseif($value -le 74)
            {
            Write-Host "Resource Groups".PadRight(18) "$percentage".PadRight(18) "$currentRG".PadRight(11) $maxRG -ForegroundColor Green
            }
            elseif(($value -ge 75) -and ($percentage -le 89))
                { 
                Write-Host "Resource Groups".PadRight(18) "$percentage".PadRight(18) "$currentRG".PadRight(11) $maxRG -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "ResourcesGroups".PadRight(18) "$percentage".PadRight(18) "$currentRG".PadRight(11) $maxRG -ForegroundColor Red
                }

 } 
{($SCOPE -eq "CORE-LIMIT") -or ($SCOPE -eq "ALL")}
{   
        $maxVMCores = ($NAUsageCoresLimit + $EUUsageCoresLimit + $USGOVUsageCoresLimit + $ASIAUsageCoresLimit + $BRAZILUsageCoresLimit + $JAPANUsageCoresLimit + $AUUsageCoresLimit + $INDIAUsageCoresLimit)
        $currentVMCores = ($NAUsageCores + $EUUsageCores + $USGOVUsageCores + $ASIAUsageCores + $BRAZILUsageCores + $JAPANUsageCores + $AUUsageCores + $INDIAUsageCores)
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
{($SCOPE -eq "STORAGEACCOUNT") -or ($SCOPE -eq "ALL")}
{
        $maxStorageAccounts     = 100

        $currentStorageAccounts = (Get-AzureRmStorageAccount).StorageAccountName.count

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
{($SCOPE -eq "VM") -or ($SCOPE -eq "ALL")}
{
        $maxVMs = ($NAUsageVMLimit + $EUUsageVMLimit + $USGOVUsageVMLimit + $ASIAUsageVMLimit + $BRAZILUsageVMLimit + $JAPANUsageVMLimit + $AUUsageVMLimit + $INDIAUsageVMLimit)
        $Azurevmcount = ($NAUsageVM + $EUUsageVM + $USGOVUsageVM + $ASIAUsageVM + $BRAZILUsageVM + $JAPANUsageVM + $AUUsageVM + $INDIAUsageVM)
        $percentage = ($Azurevmcount/$maxVMs ).ToString("P")
        $value = ($Azurevmcount/$maxVMs )*100

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
{($SCOPE -eq "AVAILSET") -or ($SCOPE -eq "ALL")}
{
        $maxAS = ($NAUsageASLimit+ $EUUsageASLimit + $USGOVUsageASLimit + $ASIAUsageASLimit + $BRAZILUsageASLimit + $JAPANUsageASLimit + $AUUsageASLimit + $INDIAUsageASLimit)
        $AzureAScount = ($NAUsageAS + $EUUsageAS + $USGOVUsageAS + $ASIAUsageAS + $BRAZILUsageAS + $JAPANUsageAS + $AUUsageAS + $INDIAUsageAS)
        $percentage = ($AzureAScount/$maxAS ).ToString("P")
        $value = ($AzureAScount/$maxAS )*100

        if($Azurevmcount -eq 0)
        {
        Write-Host "AVAILSET".PadRight(18) "$percentage".PadRight(18) "$AzureAScount".PadRight(11) $maxAS -ForegroundColor Green
        }
        elseif($value -le 74)
            {
            Write-Host "AVAILSET".PadRight(18) "$percentage".PadRight(18) "$AzureAScount".PadRight(11) $maxAS -ForegroundColor Green
            }
            elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "AVAILSET".PadRight(18) "$percentage".PadRight(18) "$AzureAScount".PadRight(11) $maxAS -ForegroundColor Yellow
                }
            elseif($value -ge 90)
                {
                Write-Host "AVAILSET".PadRight(18) "$percentage".PadRight(18) "$AzureAScount".PadRight(11) $maxAS -ForegroundColor Red
                }

}
{($SCOPE -eq "VNET") -or ($SCOPE -eq "ALL")}
{
        $maxVNET     = 50
        $currentVNET = (Get-AzureRmVirtualNetwork).Name.count
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
{($SCOPE -eq "DNS-SERVERS") -or ($SCOPE -eq "ALL")}
{
        $maxDNSServers     = 100

        $currentDNSServers = (Get-AzureRmVirtualNetwork).DhcpOptions.DnsServers.Count

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
}

switch($DETAIL)
{
{($DETAIL -eq "VMDETAIL") -or ($DETAIL -eq "ALL")}
{

Write-Host "`nBelow are Virtual Machine Region Limit in Detail`n"
Write-Host "Region             PercentageUsed(%)  CurrentUse  Max Limit"
write-Host "--------           ----------------   ----------  ---------"
        
        foreach($specifiedRegionArray in $RegionsArray){
            foreach($specifiedRegion in $specifiedRegionArray)
            {
            
            $i = 0
            $RegionUsage = (Get-AzureRmVMUsage -Location $specifiedRegion)
            $RUsageAS = $RegionUsage.CurrentValue[$i]
            $RUsageASLimit = $RegionUsage.Limit[$i++]
            $RUsageCores = $RegionUsage.CurrentValue[$i]
            $rUsageCoresLimit = $RegionUsage.Limit[$i++]
            $RUsageVM = $RegionUsage.CurrentValue[$i]
            $RUsageVMLimit = $RegionUsage.Limit[$i]

            $percentage = ($RUsageVM/$RUsageVMLimit).ToString("P")
            $value = ($vmCount/$RUsageVMLimit)*100

         if($value -eq 0)
            {
            Write-Host "$specifiedRegion".PadRight(18) "$percentage".PadRight(18) "$RUsageVM".PadRight(11) "$RUsageVMLimit" -ForegroundColor Green
            }
            elseif($value -le 74)
                {
                Write-Host "$specifiedRegion".PadRight(18) "$percentage".PadRight(18) "$RUsageVM".PadRight(11) "$RUsageVMLimit" -ForegroundColor Green
                }
                elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "$specifiedRegion".PadRight(18) "$percentage".PadRight(18) "$RUsageVM".PadRight(11) "$RUsageVMLimit" -ForegroundColor Yellow
                }
                elseif($value -ge 90)
                    {
                    Write-Host "$specifiedRegion".PadRight(18) "$percentage".PadRight(18) "$RUsageVM".PadRight(11) "$RUsageVMLimit" -ForegroundColor Red
                    }
            $RUsageVM = $null                                                          
        }
     }                               
 } 
{($DETAIL -eq "RGDETAIL") -or ($DETAIL -eq "ALL")}
{

Write-Host "`nBelow are Resource Group Limit in Detail`n"
Write-Host "RG Name         Location        PercentageUsed(%)  CurrentUse  Max Limit"
write-Host "------------    --------        ----------------   ----------  ---------"

        $RGNameArray = @((Get-AzureRmResourceGroup).ResourceGroupName)
        #$RGNamecount = (Get-AzureRmResourceGroup).Count

        foreach($rgItem in $RGNameArray)
        {
            $RGLocation = (Get-AzureRmResourceGroup -Name $rgItem).Location
            $RGCurrentUse = (Get-AzureRmResource -ResourceGroupName $rgItem -ResourceName " ").ResourceName.count

            $percentage = ($RGCurrentUse/$maxRG).ToString("P")
            $value = ($RGCurrentUse/$maxRG)*100
            
            if($rgItem.Length -ge 14){
            $rgItem = $rgItem.substring(0,14)
            }
            if($RGLocation.Length -ge 14){
            $RGLocation = $RGLocation.substring(0,14)
            }
                  
         if($value -eq 0)
            {
            Write-Host "$rgItem".PadRight(15) "$RGLocation".PadRight(15) "$percentage".PadRight(18) "$RGCurrentUse".PadRight(11) $maxRG -ForegroundColor Green
            }
            elseif($value -le 74)
                {
                Write-Host "$rgItem".PadRight(15) "$RGLocation".PadRight(15) "$percentage".PadRight(18) "$RGCurrentUse".PadRight(11) $maxRG -ForegroundColor Green
                }
                elseif(($value -ge 75) -and ($percentage -le 89))
                {
                Write-Host "$rgItem".PadRight(15) "$RGLocation".PadRight(15) "$percentage".PadRight(18) "$RGCurrentUse".PadRight(11) $maxRG -ForegroundColor Yellow
                }
                elseif($value -ge 90)
                    {
                    Write-Host "$rgItem".PadRight(15) "$RGLocation".PadRight(15) "$percentage".PadRight(18) "$RGCurrentUse".PadRight(11) $maxRG -ForegroundColor Red
                    }
                             
                  $RGCurrentUse = $null
        }
           
 }
}