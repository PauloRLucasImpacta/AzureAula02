# Configurando o provider do Microsoft Azure
terraform {
    required_version = ">=0.13"
    required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "~>2.46"
    }
  }
}
provider "azurerm" {
    features {
    }
}

# Criando um resource group para armazenamento dos itens criados
resource "azurerm_resource_group" "aula02" {
    name     = "aula02"
    location = "eastus"
}
