
# Create network interface
resource "azurerm_network_interface" "vm_nic" {
  name                = var.vm_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associate security group and the network interface
resource "azurerm_network_interface_security_group_association" "nsg_nic" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = var.nsg

}

resource "azurerm_ssh_public_key" "public_key" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  public_key          = file(var.public_key_location)
  tags                = var.tags
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = var.vm_size
  tags                  = var.tags


  os_disk {
    name                 = var.vm_name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = azurerm_ssh_public_key.public_key.public_key
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_linux_virtual_machine.vm.private_ip_address
      user        = "azureuser"
      agent       = true
      script_path = "/home/azureuser/user-data-check.sh"
    }
    inline = [
      "echo Connected",
    ]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u azureuser -i '${self.private_ip_address},' ./../ansible/playbook.yml"
  }
}

