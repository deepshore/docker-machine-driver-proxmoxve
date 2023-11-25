package main

import (
	"os"
	"testing"

	"github.com/luthermonson/go-proxmox"
	"github.com/stretchr/testify/assert"
)

func createDriver() *Driver {
	newDriver := NewDriver("default", "")
	d := newDriver.(*Driver)
	d.driverDebug = true
	return d
}

func Test_SSHKeyGeneration(t *testing.T) {
	var driver = createDriver()

	err := os.MkdirAll("machines/default", 0755)
	assert.Nil(t, err)

	s, err := driver.createSSHKey()

	assert.Nil(t, err)
	assert.NotEmpty(t, s)
}

func Test_VMIDRange(t *testing.T) {
	var driver = createDriver()
	driver.VMIDRange = "100:200"

	vmid, err := driver.GetVmidInRange()

	assert.Nil(t, err)
	assert.NotEmpty(t, vmid)

	// assert that vmid is an int between 100 and 200
	assert.True(t, vmid >= 100 && vmid <= 200)
}

func Test_VMIDRangeBroken(t *testing.T) {
	var driver = createDriver()
	driver.VMIDRange = "100"

	s, err := driver.GetVmidInRange()

	assert.NotNil(t, err)
	assert.EqualError(t, err, "VMIDRange must be in the form of <min>:<max>. Given: 100")
	assert.Empty(t, s)

	driver.VMIDRange = "100:50"

	s2, err2 := driver.GetVmidInRange()

	assert.NotNil(t, err2)
	assert.EqualError(t, err2, "VMIDRange :<max> must be greater than <min>. Given: 100:50")
	assert.Empty(t, s2)
}

func Test_AppendSshKeys(t *testing.T) {

	var driver = createDriver()

	// mock vm struct
	vm := &proxmox.VirtualMachine{
		VirtualMachineConfig: &proxmox.VirtualMachineConfig{
			Name:    "test",
			SSHKeys: "asd",
		},
	}

	SSHKeys, err := driver.appendVmSshKeys(vm)

	assert.Nil(t, err)
	assert.Contains(t, SSHKeys, "asd%0Assh-rsa")
}
