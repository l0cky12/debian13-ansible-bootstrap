terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
}

resource "proxmox_lxc" "docker_host" {
  target_node  = var.target_node
  hostname     = var.hostname
  description  = var.description
  ostemplate   = var.ostemplate
  password     = var.root_password
  start        = true
  unprivileged = true
  tags         = join(",", var.tags)

  cores      = var.cores
  memory     = var.memory
  swap       = var.swap
  nameserver = var.nameserver

  ssh_public_keys = file(var.ssh_public_key_path)

  features {
    nesting = true
    keyctl  = true
  }

  rootfs {
    storage = var.storage
    size    = var.disk_size
  }

  network {
    name   = "eth0"
    bridge = var.bridge
    ip     = var.ipv4_cidr
    gw     = var.gateway
    tag    = var.vlan_tag
  }

  provisioner "file" {
    source      = var.ssh_public_key_path
    destination = "/tmp/bootstrap.pub"

    connection {
      type        = "ssh"
      host        = var.provision_host
      user        = "root"
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "DEBIAN_FRONTEND=noninteractive apt-get update -y",
      "DEBIAN_FRONTEND=noninteractive apt-get install -y sudo",
      "id -u ${var.bootstrap_user} >/dev/null 2>&1 || adduser --disabled-password --gecos '' ${var.bootstrap_user}",
      "echo '${var.bootstrap_user}:${var.bootstrap_user_password}' | chpasswd",
      "usermod -aG sudo ${var.bootstrap_user}",
      "install -d -m 700 -o ${var.bootstrap_user} -g ${var.bootstrap_user} /home/${var.bootstrap_user}/.ssh",
      "install -m 600 -o ${var.bootstrap_user} -g ${var.bootstrap_user} /tmp/bootstrap.pub /home/${var.bootstrap_user}/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      host        = var.provision_host
      user        = "root"
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
      sleep 10
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i ${var.ansible_inventory_path} \
        -u root \
        ${var.ansible_playbook_path}
    EOT
  }
}

output "lxc_name" {
  value = proxmox_lxc.docker_host.hostname
}

output "lxc_ip" {
  value = var.provision_host
}
