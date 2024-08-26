output "web_lb_ip" {
  description = "IP address of the Web Load Balancer"
  value       = azurerm_lb.web_lb.frontend_ip_configuration[0].private_ip_address
}

output "sql_db_connection_string" {
  description = "Connection string for the SQL Database"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
