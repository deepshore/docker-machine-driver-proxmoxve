package main

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_NewDriver(t *testing.T) {
	driver := NewDriver("default", "")

	assert.NotNil(t, driver)
}

func Test_SSHKeyGeneration(t *testing.T) {
	driver := NewDriver("default", "")
	driver.(*Driver).driverDebug = true

	err := os.MkdirAll("machines/default", 0755)
	assert.Nil(t, err)

	s, err := driver.(*Driver).createSSHKey()

	assert.Nil(t, err)
	assert.NotEmpty(t, s)
}

func Test_VMIDRange(t *testing.T) {
	driver := NewDriver("default", "")
	driver.(*Driver).driverDebug = true
	driver.(*Driver).VMIDRange = "100:200"

	vmid, err := driver.(*Driver).GetVmidInRange()

	assert.Nil(t, err)
	assert.NotEmpty(t, vmid)

	// assert that vmid is an int between 100 and 200
	assert.True(t, vmid >= 100 && vmid <= 200)
}

func Test_VMIDRangeBroken(t *testing.T) {
	driver := NewDriver("default", "")
	driver.(*Driver).driverDebug = true
	driver.(*Driver).VMIDRange = "100"

	s, err := driver.(*Driver).GetVmidInRange()

	assert.NotNil(t, err)
	assert.EqualError(t, err, "VMIDRange must be in the form of <min>:<max>. Given: 100")
	assert.Empty(t, s)
}
