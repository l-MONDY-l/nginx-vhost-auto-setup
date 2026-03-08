# nginx-vhost-auto-setup

> Automated Nginx virtual host setup script for Linux servers.

![Linux](https://img.shields.io/badge/Platform-Linux-blue?style=for-the-badge)
![Nginx](https://img.shields.io/badge/Web%20Server-Nginx-green?style=for-the-badge)
![Automation](https://img.shields.io/badge/Focus-VHost%20Automation-orange?style=for-the-badge)

---

## Overview

`nginx-vhost-auto-setup` is a Bash script that automates the creation of Nginx virtual hosts on Linux servers.

It creates:
- website root directories
- default index page
- access and error log directories
- Nginx server block configuration
- enabled site symlink
- Nginx config validation and reload

---

## Features

- Create web root automatically
- Create default `index.html`
- Generate Nginx server block
- Enable site with symlink
- Validate configuration using `nginx -t`
- Reload Nginx automatically
- Production-friendly structure

---

## Use Cases

- Fast website provisioning
- Repetitive Nginx setup automation
- Dev / test server provisioning
- Admin scripting portfolio
- Basic hosting environment bootstrap

---

## Requirements

- Linux server
- Nginx installed
- Bash shell
- Root or sudo privileges
- Standard Nginx directory layout

---

## Installation

Clone the repository:

```bash
git clone https://github.com/I-MONDY-I/nginx-vhost-auto-setup.git
cd nginx-vhost-auto-setup
```

## Make the script executable:

```bash
chmod +x nginx_vhost_setup.sh
```
## Usage
Run with the domain name:

```bash
sudo ./nginx_vhost_setup.sh example.com /var/www /etc/nginx/sites-available /etc/nginx/sites-enabled www-data
```

Arguments:

 Domain

 Web root base

 Nginx sites-available path

 Nginx sites-enabled path

 Nginx user
