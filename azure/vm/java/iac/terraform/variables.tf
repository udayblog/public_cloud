variable "public_key_location" {
  default     = "~/.ssh/id_rsa.pub"
  description = "Public key that will be added into authorized keys on the vm"
}
variable "private_key_location" {
  default     = "~/.ssh/id_rsa"
  description = "Private key associated with the public key that can be used to login to vm"
}

variable "vm_name" {
  default = "demo_vm"
  description = "Name of the vm"
}
  
variable "vm_size" {
  default = "Standard_D2s_v4"
  description = "Size for the vm which can be looked up from Azure vm sizes"
}

variable "resource_group_name" {
  default     = "rg-demo"
  description = "Resource group name with which vm will be associated"
}

variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "tags" {
  description = "Map of the tags to use for the resources that are deployed"
  type        = map(string)
  default = {
    sub_type    = "demo"
  }
}

variable "nsg" {
  default     = ""
  description = "Long id of the network security group."
}

variable "subnet_id" {
  default     = ""
  description = "Long id of the subnet id."
}

