Add-AzureRmAccount -SubscriptionName "Microsoft Azure Internal Consumption"

#region CREATE NEW AUTOMATION ACCOUNT
####-------------------------------------------------
$RG = New-AzureRmResourceGroup -Name "DSCDemo" -Location "East US 2"
$RG | New-AzureRmAutomationAccount -Name DSCDemo -Plan Free
$ACT = $RG | Get-AzureRmAutomationAccount -Name dscdemo

# Get the keys for an automation account
$ACT | Get-AzureRmAutomationRegistrationInfo


# Find all cmdlets related to DSC in the Module
Get-Module AzureRM.Automation
Get-Command -Module AzureRM.Automation -Noun azurermautomationdsc*

#endregion

#region UPLOAD CONFIGURATION SCRIPTS AND COMPILE THEM TO .MOF FILES
####-------------------------------------------------------------

$AAAcct = Get-AzureRmAutomationAccount -Name DSCDemo -ResourceGroupName DSCDemo

#Import configuration script
$AAAcct | Import-AzureRmAutomationDscConfiguration -SourcePath C:\MyApps\Telnet.ps1 -Published -Force
$AAAcct | Get-AzureRmAutomationDscConfiguration -Name Telnet

#Compile configuration script and wait for compile to finish
$Job = $AAAcct | Get-AzureRmAutomationDscConfiguration -Name Telnet | Start-AzureRmAutomationDscCompilationJob
while (-not($Job | Get-AzureRmAutomationDscCompilationJob).EndTime){ Start-Sleep -Seconds 3 }

$AAAcct | Get-AzureRmAutomationDscNodeConfiguration

#endregion

#region ADD NODES TO DSC
####-------------------------------------------------

$AAAcct = Get-AzureRmAutomationAccount -Name DSCDemo -ResourceGroupName DSCDemo

#NOTE: Copy the TemplateLink Uri that shows up after running the below command
$AAAcct | Register-AzureRmAutomationDscNode -AzureVMName "WinSQLSrv" -AzureVMResourceGroup "datafactory-trials"


#endregion

#region Explore Node

# Explore ARM Template
Invoke-WebRequest -Uri https://eus2oaasibizamarketprod1.blob.core.windows.net/automationdscpreview/azuredeployV2.json `
-OutFile C:\MyApps\deploy-temp.json

psedit C:\MyApps\deploy-temp.json


#Explore Extension Archive
Invoke-WebRequest -Uri https://eus2oaasibizamarketprod1.blob.core.windows.net/automationdscpreview/RegistrationMetaConfigV2.zip `
-OutFile C:\MyApps\RegistrationMetaConfig-temp.zip

Expand-Archive C:\MyApps\RegistrationMetaConfig-temp.zip -DestinationPath C:\USers\jovagh\Desktop\Reg

psedit C:\USers\jovagh\Desktop\Reg\RegistrationMetaConfigV2.ps1


#Login to Node via remoting
$NodeIP = (Get-AzureRmPublicIpAddress -ResourceGroupName datafactory-trials).IpAddress

###########Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $NodeIP

Enter-PSSession -ComputerName $NodeIP -Credential $NodeIP\jomit


## Run these below commands in the remote vm

Get-DscLocalConfigurationManager
Get-ChildItem -Path Cert:\LocalMachine\My

Update-DscConfiguration -Wait -Verbose
Get-DscConfiguration
Test-DscConfiguration
Get-ChildItem -Path c:\*.txt
Get-Content -Path c:\*.txt

#endregion










