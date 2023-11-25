
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

install:
	docker-machine --version && mv docker-machine-driver-proxmoxve /usr/local/bin/docker-machine-driver-proxmoxve

uninstall:
	docker-machine --version && rm -f /usr/local/bin/docker-machine-driver-proxmoxve

integration-test: clean build
	
	docker-machine --debug \
    create \
    --driver proxmoxve \
    --proxmoxve-proxmox-host $$PVE_HOST \
    --proxmoxve-proxmox-node $$PVE_NODE \
    --proxmoxve-proxmox-user-name $$PVE_USER \
    --proxmoxve-proxmox-user-password $$PVE_PASSWD \
    --proxmoxve-proxmox-realm $$PVE_REALM \
    --proxmoxve-proxmox-pool "$$PVE_POOL" \
    --proxmoxve-provision-strategy clone \
    --proxmoxve-vm-clone-vmid $$PVE_TEMPLATE_ID \
    --proxmoxve-vm-memory 8 \
    --proxmoxve-ssh-username $$PVE_SSH_USER \
    --proxmoxve-ssh-password $$PVE_PASSWD \
    --proxmoxve-vm-vmid-range 8500 \
    \
    --proxmoxve-debug-driver \
    \
    $$VM_NAME