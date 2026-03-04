variable "pm_api_url" {
  description = "Proxmox API URL, e.g. https://pve.local:8006/api2/json"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox API token ID, e.g. terraform@pve!terraform-packer"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Set true when Proxmox uses self-signed certs"
  type        = bool
  default     = true
}

variable "target_node" {
  type    = string
  default = "pve"
}

variable "hostname" {
  type    = string
  default = "docker-lxc"
}

variable "description" {
  type    = string
  default = "LXC built by Terraform for Docker workloads"
}

variable "ostemplate" {
  type    = string
  default = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = list(string)
  default = ["Debian13", "Docker"]
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "swap" {
  type    = number
  default = 1024
}

variable "nameserver" {
  type    = string
  default = "192.168.1.90"
}

variable "storage" {
  type    = string
  default = "local-lvm"
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ipv4_cidr" {
  type    = string
  default = "10.2.1.20/24"
}

variable "gateway" {
  type    = string
  default = "10.2.1.1"
}

variable "vlan_tag" {
  type    = number
  default = 2
}

variable "provision_host" {
  description = "IP used by remote-exec SSH"
  type        = string
  default     = "10.2.1.20"
}

variable "ssh_public_key_path" {
  type    = string
  default = "/home/liam/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  type    = string
  default = "/home/liam/.ssh/id_rsa"
}

variable "bootstrap_user" {
  type    = string
  default = "liam"
}

variable "bootstrap_user_password" {
  type      = string
  sensitive = true
  default   = "password"
}

variable "ansible_inventory_path" {
  type    = string
  default = "ansible/inventory/inventory.ini"
}

variable "ansible_playbook_path" {
  type    = string
  default = "ansible/playbooks/debian13_full.yml"
}
