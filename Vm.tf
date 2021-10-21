#Criando a Network Interface para a vm
resource "azurerm_network_interface" "nic-aula02" {
  name                = "aula02-nic"
  location            = azurerm_resource_group.aula02.location
  resource_group_name = azurerm_resource_group.aula02.name

  ip_configuration {
    name                          = "nic-aula02"
    subnet_id                     = azurerm_subnet.sb-aula02.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip-aula02.id
  }
}

#Criando a Network interface security group
resource "azurerm_network_interface_security_group_association" "nisg-aula02" {
  network_interface_id      = azurerm_network_interface.nic-aula02.id
  network_security_group_id = azurerm_network_security_group.nsg-aula02.id
}

#Criação de IP Público
resource "azurerm_public_ip" "ip-aula02" {
  name                = "aula02-PublicIP"
  resource_group_name = azurerm_resource_group.aula02.name
  location            = azurerm_resource_group.aula02.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

#Criando a máquina virtual
resource "azurerm_virtual_machine" "vm-aula02" {
  name                  = "aula02-vm-principal"
  location              = azurerm_resource_group.aula02.location
  resource_group_name   = azurerm_resource_group.aula02.name
  network_interface_ids = [azurerm_network_interface.nic-aula02.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "VmPrincipal"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}