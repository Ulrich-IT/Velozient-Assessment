variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "myResourceGroup"
}

variable "location" {
  description = "Azure region for the resources"
  default     = "west US2"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  default     = "myVNet"
}

variable "admin_username" {
  description = "Admin username for VMs"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  default     = "P@ssw0rd100%"
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  default     = "sql-server-prod-001"
}

variable "sql_admin_username" {
  description = "SQL Server admin username"
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL Server admin password"
  default     = "P@ssw0rd100%"
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
  default     = "mySqlDatabase"
}

variable "subid" {
  description = "Subscription ID"
  default     = "6fd78bbb-2fc2-4e03-807b-efe09996e9a2"
}
