import os
from azure.identity import DefaultAzureCredential
from azure.mgmt.monitor import MonitorManagementClient
from azure.mgmt.monitor.models import MetricAlertResource, MetricCriteria, MetricAlertSingleResourceMultipleMetricCriteria
from azure.mgmt.resource import ResourceManagementClient
from azure.core.exceptions import HttpResponseError

# Set up credentials and clients
credential = DefaultAzureCredential()
subscription_id = "6fd78bbb-2fc2-4e03-807b-efe09996e9a2" # Replace with your actual subscription ID

monitor_client = MonitorManagementClient(credential, subscription_id)
resource_client = ResourceManagementClient(credential, subscription_id)

# Define constants
resource_group_name = "myResourceGroup"
vm_name = "web-vm-1"
location = "westus2"  

# Get the VM resource ID
vm_resource_id = (
    f"/subscriptions/{subscription_id}/resourceGroups/{resource_group_name}/providers/Microsoft.Compute/virtualMachines/{vm_name}"
)

# Function to create or update a metric alert
def create_or_update_metric_alert(alert_name, metric_name, operator, threshold):
    try:
        # Create the metric criteria
        metric_criteria = MetricCriteria(
            name=f"{alert_name}Criteria",  # Unique name for the criteria
            metric_name=metric_name,
            operator=operator,
            threshold=threshold,
            time_aggregation="Average"
        )

        # Create the alert
        metric_alert = MetricAlertResource(
            location=location,
            description=f"Alert for {metric_name} {operator} {threshold}",
            enabled=True,
            severity=3,
            scopes=[vm_resource_id],
            criteria=MetricAlertSingleResourceMultipleMetricCriteria(all_of=[metric_criteria]),
            actions=[],
            auto_mitigate=False,
            evaluation_frequency="PT1M",
            window_size="PT5M"
        )
        
        # Create or update the alert
        alert = monitor_client.metric_alerts.create_or_update(
            resource_group_name, alert_name, metric_alert
        )
        print(f"Alert '{alert_name}' created successfully.")
        return alert

    except HttpResponseError as e:
        print(f"An error occurred: {e.message}")
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")

# Set up alerts for CPU usage and memory usage
create_or_update_metric_alert("CPUUsageAlert", "Percentage CPU", "GreaterThan", 80)
create_or_update_metric_alert("MemoryUsageAlert", "Available Memory Bytes", "LessThan", 500000000)

# List all active alerts
alerts = monitor_client.metric_alerts.list_by_subscription()
for alert in alerts:
    print(f"Alert: {alert.name}, Status: {'Enabled' if alert.enabled else 'Disabled'}")

print("Monitoring setup complete.")
