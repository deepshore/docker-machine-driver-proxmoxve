# Docker Machine Driver for Proxmox VE (Deepshore edition)

This driver can be used to kickstart a VM in Proxmox VE to be used with Docker/Docker Machine.

* NOTE: docker-machine is not actively developed anymore so rancher/machine should be used as cli: https://github.com/rancher/machine

* [Download](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/releases) and copy it into your `PATH` (don't forget to `chmod +x`) or build your own driver
* Check if it works with this super long commandline:

        [[ $(docker-machine create --driver proxmoxve --help | grep -c "proxmoxve-proxmox-host") == 1 ]] && echo "Proxmox Driver is installed" || echo "Proxmox Driver not found"

## Driver Options

explore them with `docker-machine create --driver proxmoxve --help`

### Clone VM

To use this driver you need to have a VM template with cloud-init support.

But do not worry, we have everything in place to get you running: go to the [ansible Folder](./ansible/Readme.md) and check the Readme.md

### Build and Test

- `make`
- or to fully test create an .env file (example below) and run `make create-machine`:
   ```.env
        PVE_CLONE_VMID=100
        PVE_SSH_USER=ubuntu
        PVE_PASSWD=secret
        PVE_REALM=pam
        PVE_HOST=PVE01.local
        PVE_NODE=PVE01
        PVE_USER=root
        VM_NAME="docker-machine-pve-local"
   ```

#### Test

`make test`

## Changes

### Version v5.0.1-ds

- Add settings for task timeout and task interval (for slow pve systems and connections) 
- Update of [pve driver](https://github.com/luthermonson/go-proxmox) to v0.0.0-beta6

### Version v5.0.0-ds

- General Rewrite of driver by using a new api driver for pve https://github.com/luthermonson/go-proxmox (tested for pve6,7,8)
- Dropped support for isos
- Improved workflow to execute go test and produce outputs in PRs
- Added Makefile for all ci / cd steps

### Version v.4.0.4-ds

* Dependency updates
* automated go mod build and release point in github

### Version 4

* [support for using clones+cloud-init](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/34) (Thanks to @travisghansen)
* [enable custom network bridge without vlan tag](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/30) (Thanks to @guyguy333)
* [including args to choice scsi model](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/28) (Thanks to @bemanuel)
* [fix remove error, add further flags](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/26) (Thanks to @Psayker)

### Version 3

* [Renaming driver from `proxmox-ve` to `proxmoxve` due to identification problem with RancherOS's K8S implementation](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/18) (Thanks to [`@Sellto` for reporting #16](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/issues/16))
* fixing issue with created disk detection (Thanks to [`@Sellto` for reporting #16](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/issues/16))
* [Add `IPAddress` property needed by rancher to know the ip address of the created VM](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/18) (Thanks to `@Sellto`)
* [Change the name of each flag for better display in the rancher `Node Templates`](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/18) (Thanks to `@Sellto`)
* [Add number of `CPU cores configuration paramater`](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/18) (Thanks to `@Sellto`)
* [LVM-thin fixes](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/24) (Thanks to `@vstconsulting`)
* [Bridge and VLAN tag support](https://github.com/lnxbil/docker-machine-driver-proxmox-ve/pull/22) (Thanks to `@bemanuel`)
* Fixing filename detection including NFS support

### Version 2

* exclusive RancherOS support due to their special Proxmox VE iso files
* adding wait cycles for asynchronous background tasks, e.g.  `create`, `stop` etc.
* use one logger engine
* add guest username, password and ssh-port as new command line arguments
* more and potentially better error handling

### Version 1

* Initial Version