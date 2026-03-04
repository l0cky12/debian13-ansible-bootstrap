# Debian 13 + Proxmox Ansible Bootstrap

Playbooks for Debian 13 hardening/bootstrap and Proxmox API automation setup.

## Folder structure

- `ansible/playbooks/debian13_full.yml`: Includes Docker install, `liam` + `docker` users, and `/home/docker/docker`.
- `ansible/playbooks/debian13_nodocker.yml`: Same baseline setup but excludes Docker packages and the `docker` user.
- `ansible/playbooks/proxmox_terraform_packer_token.yml`: Creates Proxmox automation user/role/token for Terraform and Packer.
- `ansible/inventory/inventory.ini`: Example inventory.

## Debian 13 playbooks configure

- Packages: neovim, git, net-tools, bind9, curl, fail2ban, gzip, bat, screenfetch, traceroute, whois, ufw, unattended-upgrades
- SSH hardening (`PermitRootLogin no`, controlled `AllowUsers`, fail2ban enabled)
- UFW firewall (deny incoming, allow outgoing, allow OpenSSH + DNS)
- unattended-upgrades enabled

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
```

## Important

- Debian playbooks intentionally use the password `password` for requested users. Change this before production use.
- Ensure you can still access SSH after `AllowUsers` changes.
- Proxmox token secrets are shown only once by Proxmox.
