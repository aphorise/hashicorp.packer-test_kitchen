#!/bin/bash
export DEBIAN_FRONTEND=noninteractive ;
set -eu ; # abort this script when a command fails or an unset variable is used.
#set -x ; # echo all the executed commands.

# Install open-vm-tools for Vagrant, curl & other common CLI needed
apt-get -yq install open-vm-tools curl jq nginx ;

# Add /mnt/hgfs so the mount works automatically with Vagrant
mkdir -p /mnt/hgfs

# Cleanup tools iso
rm -f /home/vagrant/linux.iso
