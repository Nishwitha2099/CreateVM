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

resource "azurerm_network_security_group" "myTerraformNSG" {
  name                = var.nsgName
  location            = var.location
  resource_group_name = azurerm_resource_group.myTerraformGroup.name

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

  tags = var.tags
}

resource "azurerm_network_interface" "myTerraformNic" {
  name                = var.nicName
  location            = var.location
  resource_group_name = azurerm_resource_group.myTerraformGroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.myTerraformSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myTerraformIPAddress.id
  }
}
resource "azurerm_network_interface_security_group_association" "NICAssociationWithNSG" {
  network_interface_id      = azurerm_network_interface.myTerraformNic.id
  network_security_group_id = azurerm_network_security_group.myTerraformNSG.id
}

resource "random_id" "randomId" {
  keepers = {
    resource_group_name      = azurerm_resource_group.myTerraformGroup.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "myTerraformStorageAccpunt" {
  name                     = "dia${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myTerraformGroup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "myTerraformVM" {
  name                = var.vm
  resource_group_name = azurerm_resource_group.myTerraformGroup.name
  location            = var.location
  size                = "Standard_DC8s_v3"
  generation          = 1
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.myTerraformNic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  computer_name = var.vm
  disable_password_authentication = true 
}


