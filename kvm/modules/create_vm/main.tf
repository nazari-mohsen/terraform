resource "libvirt_volume" "disk" {
  count          = var.num_vms
  name           = var.hostname
  base_volume_id = var.base_volume_id
  pool           = var.pool
  size           = var.size_disk
}


resource "libvirt_domain" "vm" {
  count  = var.num_vms
  name   = var.hostname
  memory = var.memory
  vcpu   = var.vcpu

  network_interface {
    network_name   = "default"
    macvtap        = "yes"
    hostname       = var.hostname
    wait_for_lease = true
  }

  cloudinit = var.cloudinit_id

  disk {
    volume_id = libvirt_volume.disk[count.index].id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}


output "vm_ips" {
  value = [for vm in libvirt_domain.vm : vm.network_interface[0].addresses]
}

