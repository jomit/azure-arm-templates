#https://s1events.azure-automation.net/webhooks?token=QuuZYptz71QsuCTjzuTngZLX9SbzFNaYunzwkbWqH5c%3d

#Webhook with smaller expiration : https://s1events.azure-automation.net/webhooks?token=vT%2bEjNkxqlQSTB3%2fyAND%2bmGduiliqg%2fRhac2rr%2fbc1M%3d
#Webook with longer expiration: https://s1events.azure-automation.net/webhooks?token=pcyldOjpZyPpUt6L4JUeghwnOontqIj7F%2bZDiJW6qvQ%3d
#1) Alert name should be less than 32 characters

#Login-AzureRmAccount

#Select-AzureRmSubscription -SubscriptionName "Microsoft Azure Internal Consumption"


#$resourceId = ‘/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/datafactory-trials/providers/Microsoft.Compute/virtualMachines/WinSQLSrv’
$resourceId = '/subscriptions/d0c802cd-23ce-4323-a183-5f6d9a84743e/resourceGroups/datafactory-trials/providers/Microsoft.Storage/storageAccounts/sourcestorageac/services/blob'
#Get-AzureRmMetricDefinition –ResourceId $resourceId -DetailedOutput


$timespan = New-TimeSpan -Hours 1 # Period of time to check for the ruling
$operator = "GreaterThan" # GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual
$threshold = 50 # Percent as a whole number, or total units, depending on the alert
$timeAggregationOperator = "Maximum" # Average, Last, Maximum, Minimum, Total
 
$emailAction = New-AzureRmAlertRuleEmail -CustomEmails "jovagh@micrososft.com" -SendToServiceOwners:$false
$webhookAction = New-AzureRmAlertRuleWebhook -ServiceUri "https://s1events.azure-automation.net/webhooks?token=vT%2bEjNkxqlQSTB3%2fyAND%2bmGduiliqg%2fRhac2rr%2fbc1M%3d"

Add-AzureRmMetricAlertRule -Name "blob_AuthorizationError" `
    -Description "More than $threshold% of our requests failed with unauthorized access over the last $($timespan.ToString()) h:m:s" `
    -ResourceGroup "datafactory-trials" `
    -TargetResourceId $resourceId `
    -MetricName PercentAuthorizationError `
    -Operator $operator `
    -Threshold $threshold `
    -WindowSize $timespan `
    -Location "West US" `
    -TimeAggregationOperator $timeAggregationOperator `
    -Actions ($webhookAction, $emailAction) `
    -Debug 
