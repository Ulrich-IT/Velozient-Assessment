import os
from azure.identity import DefaultAzureCredential
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.monitor.models import MetricAlertResource, MetricCriteria
from azure.mgmt.resource import ResourceManagementClient

# Set up credentials and clients
credential = DefaultAzureCredential()
subscription_id = "6fd78bbb-2fc2-4e03-807b-efe09996e9a2"  # Ensure this is correct

monitor_client = MonitorManagementClient(credential, subscription_id)
resource_client = ResourceManagementClient(credential, subscription_id)

# Define constants
resource_group_name = "myResourceGroup"
vm_name = "sql-server-prod-001"
location = "westus2"  

# Get the VM resource ID
vm_resource_id = (
    f"/subscriptions/{subscription_id}/resourceGroups/{resource_group_name}/providers/Microsoft.Compute/virtualMachines/{vm_name}"
)

# Create or update a metric alert
def create_or_update_metric_alert(alert_name, metric_name, operator, threshold):
    try:
        metric_alert = MetricAlertResource(
            location=location,
            description=f"Alert for {metric_name} > {threshold}",
            enabled=True,
            severity=3,
            scopes=[vm_resource_id],
            criteria=[
                MetricCriteria(
                    name=f"{metric_name}_criteria",
                    metric_name=metric_name,
                    operator=operator,
                    threshold=threshold,
                    time_aggregation="Average"
                )
            ],
            actions=[],
            auto_mitigate=False,
            evaluation_frequency="PT1M",
            window_size="PT5M"
        )
        alert = monitor_client.metric_alerts.create_or_update(
            resource_group_name, alert_name, metric_alert
        )
        print(f"Alert '{alert_name}' created or updated successfully.")
        return alert
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

# Set up alerts for CPU usage and memory usage
create_or_update_metric_alert("CPUUsageAlert", "Percentage CPU", "GreaterThan", 80)
create_or_update_metric_alert("MemoryUsageAlert", "Available Memory Bytes", "LessThan", 500000000)

# List all active alerts
alerts = monitor_client.metric_alerts.list_by_subscription()
for alert in alerts:
    print(f"Alert: {alert.name}, Status: {'Enabled' if alert.enabled else 'Disabled'}")

print("Monitoring setup complete.")
