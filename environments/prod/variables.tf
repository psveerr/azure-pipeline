variable "resource_group_name" {
  description = "Name of the Azure resource group for the prod environment."
  type        = string
  default     = "prod-rg-web"
}

variable "location" {
  description = "Azure region for the prod environment."
  type        = string
  default     = "West Europe"
}

variable "public_subnet_address_prefixes" {
  description = "Address prefix for the public subnet."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "private_subnet_address_prefixes" {
  description = "Address prefix for the private subnet."
  type        = list(string)
  default     = ["10.10.2.0/24"]
}

variable "vm_size" {
  description = "Size of the virtual machine for the prod environment (higher size)."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "vm_count" {
  description = "Number of VMs to deploy in the prod environment (scaled up)."
  type        = number
  default     = 3
}

variable "admin_password" {
  description = "Admin password for the prod VMs. Input this during apply."
  type        = string
  sensitive   = true
}