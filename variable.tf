variable "resourceGroupName" {
    type = string
}
variable "location" {
    type = string
}
variable "tags" {
    type = map(any)
}
variable "vnetname" {
    type = string
}

variable "subnetname" {
    type = string
}

variable "publicipname" {
    type = string
}
variable "nsgName" {
    type = string
}
variable "nicName" {
    type = string
}
variable "vm" {
    type = string
}