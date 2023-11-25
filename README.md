# Docker Machine Driver for Proxmox VE (Deepshore edition)

This driver can be used to kickstart a VM in Proxmox VE to be used with Docker/Docker Machine.

* [Download](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/releases) and copy it into your `PATH` (don't forget to `chmod +x`) or build your own driver
* Check if it works with this super long commandline:

        [[ $(docker-machine create --driver proxmoxve --help | grep -c "proxmoxve-proxmox-host") == 1 ]] && echo "Proxmox Driver is installed" || echo "Proxmox Driver not found"

## Driver Options

explore them with `docker-machine create --driver proxmoxve --help`

### Clone VM

To use this driver you need to have a VM template with cloud-init support.

But do not worry, we have everything in place to get you running: go to the [ansible Folder](./ansible/Readme.md) and check the Readme.md

## Changes

### Version v5.0.0-ds

- General Rewrite of driver by using a new api driver for pve https://github.com/luthermonson/go-proxmox (tested for pve6,7,8)
- Dropped support for isos
- Improved workflow to execute go test and produce outputs in PRs
- Added Makefile for all ci / cd steps