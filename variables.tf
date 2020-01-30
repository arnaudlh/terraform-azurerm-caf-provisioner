variable "tags" {
    default = {}
}

variable "scripts" {
    description = "List of the scripts to execute from the library"
    default = []
}

variable "scripts_param" {
    
}

variable "os_platform" {
    description = "(Required) Define the script os platform like 'centos', 'docker', 'windows'"
    default = ""
}

variable "operating_system" {
    description = "Target Linux or Windows operating system. Default Linux"
    default = "Linux"
}

variable "host_connection" {
  description = "(Required) - Host IP or FQDN to connect the server and execute the script"
}

variable "admin_username" {
    description = "Admin username to lo"
}

variable "ssh_private_key_pem_secret_id" {
    description = "(Optional) (Required for Linux os_platform) Map of keyvault_id and secret Id of the ssh_private_key_pem. The ssh_private_key_pem is base64encoded"
    default = null
}