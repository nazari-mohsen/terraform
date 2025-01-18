resource "libvirt_pool" "cluster" {
  name = var.cluster_name
  type = var.pool_type
  target {
    path = var.pool_path
  }
}

resource "libvirt_volume" "os_image_ubuntu" {
  name   = var.os_image
  pool   = libvirt_pool.cluster.name
  source = var.source_path
}

locals {
  vms = flatten([
    for vm in var.vm_definitions : [
      for i in range(vm.count) : {
        hostname  = "${vm.type}${i + 1}"
        memory    = vm.memory
        vcpu      = vm.vcpu
        size_disk = vm.size_disk
      }
    ]
  ])
}

data "template_file" "user_data" {
  for_each = { for idx, vm in local.vms : idx => vm }
  template = file(var.cloud_init_file)
  vars = {
    hostname = each.value.hostname
    ssh_key  = var.ssh_key
  }
}

resource "libvirt_cloudinit_disk" "vms" {
  for_each  = data.template_file.user_data
  name      = "${each.value.vars.hostname}-cloudinit.iso"
  pool      = libvirt_pool.cluster.name
  user_data = each.value.rendered
}

module "vms" {
  source         = "./modules/create_vm"
  for_each       = { for idx, vm in local.vms : idx => vm }
  hostname       = each.value.hostname
  memory         = each.value.memory
  vcpu           = each.value.vcpu
  pool           = libvirt_pool.cluster.name
  cloudinit_id   = libvirt_cloudinit_disk.vms[each.key].id
  size_disk      = each.value.size_disk
  base_volume_id = libvirt_volume.os_image_ubuntu.id
}
