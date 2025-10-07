output "resource_group_name" {
  description = "The name of the resource group created."
  value       = azurerm_resource_group.rg.name
}

output "public_subnet_id" {
  description = "The ID of the public subnet (for App Gateway)."
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet (for VMs)."
  value       = azurerm_subnet.private.id
}

output "nsg_id" {
  description = "The ID of the Network Security Group."
  value       = azurerm_network_security_group.nsg.id
}

output "location" {
  description = "The Azure region where resources are created."
  value       = azurerm_resource_group.rg.location
}