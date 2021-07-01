  resource "proxmox_vm_qemu" "krb-slave" {
    name = "krb-slave"
    desc = " a machine for testing open ldap with kerberos "
    target_node = "kvm01"

    clone = "BDAAS-CentOS-7"

    # The destination resource pool for the new VM
    pool = "to_be_deleted"
    # Proxmox Agent activation
    agent = 1
    # VM Sizing configuration
    cores = 4
    sockets = 4
    memory = 8192
    # VM CPU Model & Non-uniform memory access (NUMA) for CPU/RAM hotplug
    cpu = "kvm64"
    numa = true

    # Network configuration
    network {
      id = 0
      model = "virtio"
      bridge = "vmbr10"
    }

    # Storage configuration
    # - Option 3 : declare a disk, even if already exists
    #              give a better result, but need nonsensed parameters
    disk {
      id = 0
      type = "virtio"
      storage = "DataCeph01_vm"
      # Type of storage to set correctly, because default RAW format used instead
      storage_type = "rbd"
      # Argument needed even if the size of the disk is more
      size = 80
    }

    # Boot from hard disk (c), CD-ROM (d), network (n)
    boot = "cdn"
    # It's possible to add this type of material and use it directly
    # Possible values are: network,disk,cpu,memory,usb
    hotplug = "disk,cpu,memory,network,usb"
    # Default boot disk
    bootdisk = "virtio0"

    # Cloud-init parameters
    os_type = "cloud-init"
    # - DNS Domain
    searchdomain = "dc01.octopeek.com"
    # - DNS Servers
    nameserver = "10.10.10.200 10.10.10.201"
    # - Network settings
    ipconfig0 = "ip=10.10.10.45/24,gw=10.10.10.250"

    # Lifecycle management
    # after first network definition, do not modify network properties
    # except if modify explicitly
    lifecycle {
      ignore_changes = [
        network,
        scsihw,
      ]
    }
  }

