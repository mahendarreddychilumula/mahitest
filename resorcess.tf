
data "azurerm_resource_group" "mahendar_rsg1" {
  name = "mahendar_rsg1"
}
data "azurerm_virtual_network" "mahendar_vnet1" {
    name                = "mahendar_vnet1"
    resource_group_name = "mahendar_rsg1"
  
}
data "azurerm_subnet" "mahendar_subnet1" {
  name                 = "mahendar_subnet1"
  virtual_network_name = "mahendar_vnet1"
  resource_group_name  = "mahendar_rsg1"
}
resource "azurerm_public_ip" "test" {
    name                         = "myPublicIP-test"
    location                     =  "EAST US"
    resource_group_name          = "mahendar_rsg1"
    
   allocation_method              = "Dynamic"

}
resource "azurerm_network_interface""mahendar_ni" {
  name                = "mahendar_ni"
  location            = data.azurerm_resource_group.mahendar_rsg1.location
  resource_group_name =data.azurerm_resource_group.mahendar_rsg1.name

  ip_configuration {
    name                          = "mahendar_configuration1"
    subnet_id                     =  data.azurerm_subnet.mahendar_subnet1.id
    private_ip_address_allocation = "Dynamic"

  }
}


resource "azurerm_virtual_machine" "mahi_vm" {
  name                  = "mahi_vm"
  location              =  data.azurerm_resource_group.mahendar_rsg1.location
  resource_group_name   =  "mahendar_rsg1"
  network_interface_ids = ["${azurerm_network_interface.mahendar_ni.id}"]
  vm_size               = "Standard_DS1_v2"

  
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "mahendarst1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "mahendar11"
    admin_username = "mahendar11"
    admin_password = "Ma@1234567890"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "dev"
}
}