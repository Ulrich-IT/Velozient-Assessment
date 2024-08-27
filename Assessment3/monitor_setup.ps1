# Login to Azure
Connect-AzAccount

# Set the subscription context if needed
$subscriptionId = "6fd78bbb-2fc2-4e03-807b-efe09996e9a2" #Replace the string content to customize to your specific environment.
Select-AzSubscription -SubscriptionId $subscriptionId

# Variables #Replace the string content to customize to your specific environment.
$resourceGroupName = "myResourceGroup" 
$vmName = "web-vm-1" 
$location = "westeurope"

# Get VM details
$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

# Create or update a Log Analytics Workspace
$workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name "DefaultWorkspace" -ErrorAction SilentlyContinue
if (-Not $workspace) {
    $workspace = New-AzOperationalInsightsWorkspace -Location $location -Name "DefaultWorkspace" -Sku "PerGB2018" -ResourceGroupName $resourceGroupName
}

# Enable monitoring for the VM
Enable-AzVMInsights -ResourceGroupName $resourceGroupName -VMName $vmName -WorkspaceId $workspace.ResourceId

# Metrics and Logs configuration
Set-AzDiagnosticSetting -Name "VMInsights" `
  -ResourceId $vm.Id `
  -WorkspaceId $workspace.ResourceId `
  -MetricsConfiguration @(
      @{ 
        Category = "CPU"; 
        Enabled = $true 
      }, 
      @{ 
        Category = "Memory"; 
        Enabled = $true 
      }
    ) `
  -LogsConfiguration @(
      @{ 
        Category = "Administrative"; 
        Enabled = $true 
      }, 
      @{ 
        Category = "Security"; 
        Enabled = $true 
      }
    ) `
  -Enabled $true

# Set up an alert rule for CPU usage > 80%
$alertName = "HighCPUUsageAlert"
$actionGroupName = "DefaultActionGroup"

# Check if Action Group exists; if not, create it
$actionGroup = Get-AzActionGroup -ResourceGroupName $resourceGroupName -Name $actionGroupName -ErrorAction SilentlyContinue
if (-Not $actionGroup) {
    $actionGroup = New-AzActionGroup -ResourceGroupName $resourceGroupName -Name $actionGroupName -ShortName "DefActGrp" `
    -Receiver @(New-AzActionGroupReceiver -Name "Admin" -EmailAddress "admin@example.com")
}

# Create or update the alert rule
$condition = New-AzMetricAlertRuleV2Criteria -MetricName "Percentage CPU" -Operator GreaterThan -Threshold 80
$alertRule = New-AzMetricAlertRuleV2 -Name $alertName `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -TargetResourceId $vm.Id `
    -WindowSize 5m `
    -Frequency 1m `
    -ActionGroupId $actionGroup.Id `
    -Criteria $condition `
    -Severity 2 `
    -Enabled $true

Write-Host "Monitoring and alerts set up successfully."


# List all active alerts and their statuses
$alerts = Get-AzMetricAlertRuleV2 -ResourceGroupName $resourceGroupName
$alerts | ForEach-Object {
    Write-Host "Alert Name: $($_.Name)"
    Write-Host "Severity: $($_.Severity)"
    Write-Host "Status: $($_.Enabled)"
    Write-Host "-----------------------------"
}
