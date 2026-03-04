# Debian 13 Ansible Bootstrap

Two playbooks for Debian 13 hardening and package bootstrap.

## Folder structure

- `ansible/playbooks/debian13_full.yml`: Includes Docker install, `liam` + `docker` users, and `/home/docker/docker`.
- `ansible/playbooks/debian13_nodocker.yml`: Same baseline setup but excludes Docker packages and the `docker` user.
- `ansible/inventory/inventory.ini`: Example inventory.

## What gets configured

- Packages: neovim, git, net-tools, bind9, curl, fail2ban, gzip, bat, screenfetch, traceroute, whois, ufw, unattended-upgrades
- SSH hardening (`PermitRootLogin no`, controlled `AllowUsers`, fail2ban enabled)
- UFW firewall (deny incoming, allow outgoing, allow OpenSSH + DNS)
- unattended-upgrades enabled

## Run

```bash
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/debian13_full.yml
ansible-playbook -i ansible/inventory/inventory.ini ansible/playbooks/debian13_nodocker.yml
```

## Important

- This setup intentionally uses the password `password` for requested users. Change this before production use.
- Ensure you can still access SSH after `AllowUsers` changes.
