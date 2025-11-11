variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "udacity"
}

variable "location" {
  description = "The Azure Region in which all resources should be created"
  default     = "West Europe"
}

variable "vm_count" {
  description = "Number of VMs to create"
  default     = 2
}

variable "admin_username" {
  description = "Admin username for the VMs"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VMs"
  default     = "P@ssw0rd1234!"
}

variable "packer_image_id" {
  description = "The ID of the Packer image to use for VMs"
  default     = "/subscriptions/a9ab978b-a5d4-42b1-a453-fe2690ceb40f/resourceGroups/Azuredevops/providers/Microsoft.Compute/images/myPackerImage"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "Azuredevops"
}
