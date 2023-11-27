SHELL := /bin/bash
-include .env
export

all: clean test build

deps:
	go install "github.com/jstemmer/go-junit-report/v2@latest"

run-ci: deps clean test-ci build

build:
	go build -v

test:
	go test -v

test-ci:
	go test -v 2>&1 ./... > test-output.log
	cat test-output.log
	go-junit-report -in test-output.log -iocopy -out report.xml

clean:
	rm -f report.xml test-output.log docker-machine-driver-proxmoxve

install: build
	docker-machine --version && mv docker-machine-driver-proxmoxve /usr/local/bin/docker-machine-driver-proxmoxve

uninstall:
	docker-machine --version && rm -f /usr/local/bin/docker-machine-driver-proxmoxve

create-machine: clean build
	docker-machine --debug \
    create \
    --driver proxmoxve \
    --proxmoxve-proxmox-host $$PVE_HOST \
    --proxmoxve-proxmox-node $$PVE_NODE \
    --proxmoxve-proxmox-user-name $$PVE_USER \
    --proxmoxve-proxmox-user-password $$PVE_PASSWD \
    --proxmoxve-proxmox-realm $$PVE_REALM \
    --proxmoxve-vm-clone-vmid $$PVE_CLONE_VMID \
    --proxmoxve-vm-memory 8 \
    --proxmoxve-ssh-username $$PVE_SSH_USER \
    --proxmoxve-ssh-password $$PVE_PASSWD \
    --proxmoxve-vm-vmid-range "8500:9500" \
    --proxmoxve-debug-driver \
    $$VM_NAME

remove-machine-forcefully:
	docker-machine rm -y --force $$VM_NAME

remove-machine:
	docker-machine rm -y $$VM_NAME