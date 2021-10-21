#Criando o IP para o mysql
resource "azurerm_public_ip" "publicipmysql" {
    name                         = "aula02-pIPMySQL"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.aula02.name
    allocation_method            = "Static"
}

resource "azurerm_network_security_group" "nsgmysql" {
    name                = "aula02-NSGMySQL"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.aula02.name

    security_rule {
        name                       = "mysql"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "SSH"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

#criando a interface para o mysql
resource "azurerm_network_interface" "nic-aula02MySQL" {
    name                      = "aula02-nicMySQL"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.aula02.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.sb-aula02.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicipmysql.id
    }
}

resource "azurerm_network_interface_security_group_association" "nisgaMysql" {
    network_interface_id      = azurerm_network_interface.nic-aula02MySQL.id
    network_security_group_id = azurerm_network_security_group.nsgmysql.id
}

#IP Publico
data "azurerm_public_ip" "ip_aula_data_db" {
  name                = azurerm_public_ip.publicipmysql.name
  resource_group_name = azurerm_resource_group.aula02.name
}

#Criando Storage
resource "azurerm_storage_account" "samysql" {
    name                        = "storagemysqlaula02"
    resource_group_name         = azurerm_resource_group.aula02.name
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"
}

#Criando vc Linux
resource "azurerm_linux_virtual_machine" "vm-aula02MySQL" {
    name                  = "aula02-MySQL"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.aula02.name
    network_interface_ids = [azurerm_network_interface.nic-aula02MySQL.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDiskMySQL"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "vmMySQL"
    admin_username = "testadmin"
    admin_password = "Password1234!"
    disable_password_authentication = false

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.samysql.primary_blob_endpoint
    }

    depends_on = [ azurerm_resource_group.aula02 ]
}

resource "time_sleep" "wait_30_seconds_db" {
  depends_on = [azurerm_linux_virtual_machine.vm-aula02MySQL]
  create_duration = "30s"
}
