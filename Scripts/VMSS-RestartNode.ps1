Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName "Jomit's Internal Subscription"

Stop-AzureRmVmss -ResourceGroupName "azbeat" -VMScaleSetName "backend" -InstanceId "1"

Start-AzureRmVmss -ResourceGroupName "azbeat" -VMScaleSetName "backend" -InstanceId "1"

# All Nodes
#Start-AzureRmVmss -ResourceGroupName "azbeat" -VMScaleSetName "backend"