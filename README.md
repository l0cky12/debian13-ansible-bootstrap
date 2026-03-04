# Debian 13 + Proxmox + Arch Bootstrap

Playbooks for Debian 13 hardening/bootstrap, Proxmox API automation setup, Arch setup, and Terraform LXC provisioning.

## Folder structure

- `ansible/playbooks/debian13_full.yml`: Includes Docker install, `liam` + `docker` users, and `/home/docker/docker`.
- `ansible/playbooks/debian13_nodocker.yml`: Same baseline setup but excludes Docker packages and the `docker` user.
- `ansible/playbooks/proxmox_terraform_packer_token.yml`: Creates Proxmox automation user/role/token for Terraform and Packer.
- `ansible/playbooks/arch_setup.yml`: Arch Linux package/user/security bootstrap.
- `ansible/inventory/inventory.ini`: Example inventory.
- `main.tf` / `variables.tf` / `terraform.tfvars.example`: Terraform Proxmox LXC deployment in repo root.

## Debian 13 playbooks configure

- Packages: neovim, git, net-tools, bind9, curl, fail2ban, gzip, bat, screenfetch, traceroute, whois, ufw, unattended-upgrades
- SSH hardening (`PermitRootLogin no`, controlled `AllowUsers`, fail2ban enabled)
- UFW firewall (deny incoming, allow outgoing, allow OpenSSH + DNS)
- unattended-upgrades enabled

## Arch playbook configures

- Installs pacman packages for Docker, QEMU/KVM, Terraform/Packer, tooling, and security services
- Installs AUR packages with `yay` (e.g., brave, obsidian, spotify, sxiv, openai-codex)
- Creates user `liam` with password `mail`, `zsh` shell, and sudo (wheel)
- SSH hardening, fail2ban, and UFW baseline

## Proxmox playbook configures

- Proxmox user: `terraform@pve` (default, configurable)
- Proxmox role: `TerraformPacker` with VM/Datastore permissions
- ACL assignment on `/`
- API token creation: `terraform-packer` (default, configurable)
- Writes token details to `/root/proxmox-api-token.txt` on first creation

## Run

```bash
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/debian13_full.yml
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/debian13_nodocker.yml
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/proxmox_terraform_packer_token.yml
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/arch_setup.yml
```

## Terraform run

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Important

- Debian playbooks intentionally use the password `password` for requested users. Change this before production use.
- Ensure you can still access SSH after `AllowUsers` changes.
- Proxmox token secrets are shown only once by Proxmox.
