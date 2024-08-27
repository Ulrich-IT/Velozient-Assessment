# List all active alerts
$alerts = Get-AzMetricAlertRuleV2 -ResourceGroupName "your-resource-group-name"
$alerts | ForEach-Object {
    Write-Host "Alert Name: $($_.Name)"
    Write-Host "Severity: $($_.Severity)"
    Write-Host "Status: $($_.Enabled)"
    Write-Host "-----------------------------"
}
