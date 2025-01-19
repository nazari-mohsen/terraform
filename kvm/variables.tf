variable "libvirt_url" {
  description = "url of libvirt"
  type        = string
  default     = "qemu:///system"
}

variable "cluster_name" {
  description = "name of cluster"
  type        = string
  default     = "cluster"
}

variable "pool_type" {
  description = "Type of pool for storage"
  type        = string
  default     = "dir"
}

variable "pool_path" {
  description = "Path of pool for storage"
  type        = string
  default     = "./kvm"
}

variable "ssh_key" {
  description = "SSH public key"
  type        = string
}

variable "cloud_init_file" {
  description = "Path to the cloud-init configuration for VMs"
  type        = string
  default     = "cloud_init.cfg"
}

variable "os_image" {
  description = "OS Image"
  type        = string
  default     = "os_image_ubuntu"
}

variable "source_path" {
  description = "Path to the source configuration for ISO VMs"
  type        = string
  default     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img"
}

variable "vm_definitions" {
  description = "List of VM definitions with type, count, and specifications"
  type = list(object({
    type      = string
    count     = number
    memory    = number
    vcpu      = number
    size_disk = number
  }))
  default = []
}