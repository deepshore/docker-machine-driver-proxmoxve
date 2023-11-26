#!/usr/bin/perl
use strict;
use warnings;

print "K3S ON LXC HOOK: " . join(' ', @ARGV). "\n";

my $vmid = shift;
my $phase = shift;

if ($phase eq 'post-start') {
    #system("sleep", "30" );
    #system("pct", "push", $vmid, "/mnt/pve/cephfs/snippets/k3s-patches.sh", "/etc/rc.local" );
}

exit(0);