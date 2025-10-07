output "private_ips" {
  description = "The private IP addresses of the deployed VMs."
  value       = azurerm_network_interface.nic.*.private_ip_address
}