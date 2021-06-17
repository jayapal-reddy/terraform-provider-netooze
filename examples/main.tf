terraform {
  required_providers {
    serverspace = {
      version = "0.2"
      source  = "serverspace.by/main/serverspace"
    }
  }
}


variable "ubuntu" {
  description = "Default LTS"
  default     = "Ubuntu-18.04-X64"
}

variable "am_loc" {
  description = "am location"
  default     = "am2"
}


# resource "serverspace_isolated_network" "my_net" {
#   location    = var.am_loc
#   name        = "my_net"
#   description = "Internal network"
# }

resource "serverspace_server" "vm1" {
  name     = "vm1"
  image    = var.ubuntu
  location = var.am_loc
  cpu      = 1
  ram      = 2048

  root_volume_size = 30720 # 25600

  volume {
    name = "bar"
    size = 30720
  }

  nic {
    # network        = data.serverspace_isolated_network.my_net.id
    bandwidth = 100
  }

  ssh_keys = [

  ]


  # connection {
  #   host        = self.public_ip_addresses[0] # Read-only attribute computed from connected networks
  #   user        = "root"
  #   type        = "ssh"
  #   private_key = file(var.pvt_key)
  #   timeout     = "2m"
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "export PATH=$PATH:/usr/bin",
  #     # install nginx
  #     "sudo apt-get update",
  #     "sudo apt-get -y install nginx"
  #   ]
  # }
}

output "vm1" {
  value = serverspace_server.vm1
}
