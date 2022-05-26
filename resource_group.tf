resource "azurerm_resource_group" "myTerraformGroup" {
  name     = var.resourceGroupName
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "myTerraformNetwork" {
  name                = var.vnetname
  location            = var.location
  resource_group_name = azurerm_resource_group.myTerraformGroup.name
  address_space       = ["10.0.0.0/16"]
  tags = var.tags
 }

 resource "azurerm_subnet" "myTerraformSubnet" {
  name                 = var.subnetname
  resource_group_name  = azurerm_resource_group.myTerraformGroup.name
  virtual_network_name = azurerm_virtual_network.myTerraformNetwork.name
  address_prefixes     = ["10.0.2.0/24"]
  } 

  resource "azurerm_public_ip" "myTerraformIPAddress" {
  name                    = var.publicipname
  location                = var.location
  resource_group_name     = azurerm_resource_group.myTerraformGroup.name
  allocation_method       = "Dynamic"
  
  tags = var.tags
}
