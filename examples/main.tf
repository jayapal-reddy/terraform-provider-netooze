terraform {
  required_providers {
    netooze = {
      version = "0.2"
      source  = "netooze.com/main/netooze"
    }
  }
}


locals {
  current_location = var.am_location
}


resource "netooze_ssh" "my_ssh" {
  name       = "just a key"
  public_key = file("./ssh_key.pub")
}

resource "netooze_isolated_network" "my_net" {
  location       = local.current_location
  name           = "my_net"
  description    = "Internal network"
  network_prefix = "192.168.0.0"
  mask           = 24
}


resource "netooze_server" "vm1" {
  name     = "vm1"
  image    = var.ubuntu
  location = local.current_location
  cpu      = 1
  ram      = 2048

  boot_volume_size = 30720 # 25600

  volume {
    name = "bar1"
    size = 30720
  }

  nic {
    network      = netooze_isolated_network.my_net.id
    network_type = "Isolated"
    bandwidth    = 0
  }
  nic {
    network      = ""
    network_type = "PublicShared"
    bandwidth    = 50
  }
  nic {
    network      = ""
    network_type = "PublicShared"
    bandwidth    = 100
  }

  ssh_keys = [netooze_ssh.my_ssh.id]


  connection {
    host        = self.public_ip_addresses[0] # Read-only attribute computed from connected networks
    user        = "root"
    type        = "ssh"
    private_key = file("./ssh_key")
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      "sudo apt-get update",
      "sudo apt-get -y install --no-install-recommends nano"
    ]
  }
}


output "my_net" {
  value = netooze_isolated_network.my_net
}

output "vm1" {
  value = netooze_server.vm1
}
