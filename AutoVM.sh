#!/bin/bash
#
# Scritp made to auto create a VM environment with Virtualbox in Linux
#
# Pre requisites:
# - Linux
# - Virtualbox
#
# Author: andre@bacao.pt
# Dtae: 03/10/2016

VM='AutoVM'
TYPE_OS='Ubuntu_64'
NATname='AutoVMSnetwork'
MAC='080027D6A1A4'
HDD_SIZE='20480'
VM_MEM='4096'
NATIPRANGE='10.10.10.0/24'
ISO_LOCALE='/tmp/mini.iso'

#DOWNLOAD UBUNTU 16.04 NETWORK INSTALL
wget http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/mini.iso -O $ISO_LOCALE

#NETWORK CONFIGURATION FOR NAT NETWORK
VBoxManage natnetwork add --netname $NATname --network $NATIPRANGE --enable --dhcp on
VBoxManage natnetwork start --netname $NATname

#VM CONFIG
VBoxManage createhd --filename $VM.vdi --size $HDD_SIZE
VBoxManage createvm --name $VM --ostype $TYPE_OS --register
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi
VBoxManage storagectl $VM --name "IDE Controller" --add ide
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $ISO_LOCALE
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory $VM_MEM --vram 16
VBoxManage modifyvm $VM --audio none
VBoxManage modifyvm $VM --nic1 natnetwork --nat-network1 $NATname --macaddress1 $MAC --cableconnected1 on

#VM BOOT UP
VBoxHeadless -s $VM
