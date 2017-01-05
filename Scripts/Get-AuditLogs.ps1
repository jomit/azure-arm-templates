Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName 'Microsoft Azure Internal Consumption'
Get-AzureRmLog -ResourceProvider Microsoft.Compute –StartTime '5/25/2016' -EndTime '6/1/2016' -DetailedOutput

Get-AzureRMAuthorizationChangeLog -StartTime ([DateTime]::Now - [TimeSpan]::FromDays(7)) | FT Caller,Action,RoleName,PrincipalType,PrincipalName,ScopeType,ScopeName