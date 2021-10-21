#Arquivo criado para a exibicaoo de informações no terminal para consulta
output "public_ip_vm" {
    value = azurerm_public_ip.ip-aula02.ip_address
  
}

output "public_ip_address_mysql" {
    value = azurerm_public_ip.publicipmysql.ip_address
}