data "azurerm_key_vault_secret" "private_key_pem" {
  name         = var.ssh_private_key_pem_secret_id.name
  key_vault_id = var.ssh_private_key_pem_secret_id.key_vault_id
}


resource "null_resource" "linux_scripts_to_execute" {
    count =  ( lower(var.operating_system) == "linux" && length(var.scripts) > 0 ) ? length(var.scripts) : 0

    # TODO - to be refactored to external module to support bastion and also windows.
    connection {
        type        = "ssh"
        user        = var.admin_username
        host        = var.host_connection
        private_key = base64decode(data.azurerm_key_vault_secret.private_key_pem.value)
        agent       = false 
    }

    triggers = {
        host        = var.host_connection
    }
    

    # Deploy
    provisioner "file" {
        source      = "${path.module}/scripts/${var.os_platform}/${element(var.scripts, count.index)}"
        destination = "/home/${var.admin_username}/${element(var.scripts, count.index)}"
    }

    # Execute
    provisioner "remote-exec" {
        inline = [
            "chmod +x /home/${var.admin_username}/${element(var.scripts, count.index)}; ",
            "/home/${var.admin_username}/${element(var.scripts, count.index)} ${element(var.scripts_param, count.index)}"
        ]
    }

    # Cleanup
    provisioner "remote-exec" {
        inline = [
            "rm -f /home/${var.admin_username}/${element(var.scripts, count.index)}; ",
        ]
    }
}