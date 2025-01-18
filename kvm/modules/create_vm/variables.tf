variable "hostname" {
  description = "Hostname of the virtual machine"
  type        = string
}

variable "num_vms" {
  description = "Number of VM"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Amount of memory in MB"
  type        = number
}

variable "vcpu" {
  description = "Number of virtual CPUs"
  type        = number
}

variable "cloudinit_id" {
  description = "ID of the cloud-init disk"
  type        = string
}

variable "size_disk" {
  description = "Size of the virtual disk"
  type        = number
}

variable "base_volume_id" {
  description = "ID of the base volume"
  type        = string
}

variable "pool" {
  description = "The libvirt pool where the volume is stored"
  type        = string
}