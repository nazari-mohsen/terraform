output "vm_ips_by_type" {
  description = "Simplified list of IP addresses grouped by VM types"
  value = {
    for vm_type in distinct([for vm in local.vms : split("-", vm.hostname)[0]]) :
    vm_type => flatten([
      for idx, vm in local.vms : module.vms[idx].vm_ips
      if startswith(vm.hostname, vm_type)
    ])
  }
}
