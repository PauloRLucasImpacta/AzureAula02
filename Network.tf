#Criando a rede virtual para comunicacao
resource "azurerm_virtual_network" "vn-aula02" {
  name                = "aula02-VN1"
  location            = azurerm_resource_group.aula02.location
  resource_group_name = azurerm_resource_group.aula02.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  

  tags = {
    environment = "Production"
    turma="es22"
  }
}

#Criando a subnet
resource "azurerm_subnet" "sb-aula02" {
  name                 = "aula02-SB1"
  resource_group_name  = azurerm_resource_group.aula02.name
  virtual_network_name = azurerm_virtual_network.vn-aula02.name
  address_prefixes     = ["10.0.1.0/24"]

}


#Criando o network security group (Firewall)
resource "azurerm_network_security_group" "nsg-aula02" {
  name                = "aula02-SG1"
  location            = azurerm_resource_group.aula02.location
  resource_group_name = azurerm_resource_group.aula02.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}