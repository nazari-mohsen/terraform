# Terraform KVM Infrastructure

This project uses **Terraform** and **KVM** (Kernel-based Virtual Machine) to create various infrastructure scenarios. You simply need to provide the necessary values in the `terraform.tfvars` file, then run Terraform to set up your virtual machines.

## Prerequisites

Before starting, ensure that the following are installed on your system:

- **Terraform**: for infrastructure as code management.
- **KVM**: for creating and managing virtual machines.
- **libvirt**: for interacting with KVM.

### Installing Prerequisites on Ubuntu

#### 1. Install Terraform

1. To install Terraform on Ubuntu, you first need to download the appropriate version for your system. Run the following commands:
   ```bash
   sudo apt-get update && sudo apt-get install -y wget unzip
   wget https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip
   unzip terraform_*.zip
   sudo mv terraform /usr/local/bin/
   terraform -v
   ```
   These commands will automatically download and install the latest version of Terraform.

#### 2. Install KVM and libvirt

To install **KVM** and **libvirt** on Ubuntu-based systems, run the following commands:

1. Update and install dependencies:
   ```bash
   sudo apt update
   sudo apt install -y qemu-kvm libvirt-bin bridge-utils virt-manager
   ```

2. After installation, ensure that the `libvirt` service is running:
   ```bash
   sudo systemctl enable libvirtd
   sudo systemctl start libvirtd
   ```

3. Also, ensure that your user is added to the `libvirt` group:
   ```bash
   sudo usermod -aG libvirt $(whoami)
   ```

4. To verify the installation of KVM, run the following command:
   ```bash
   kvm-ok
   ```

   If the result is "KVM acceleration can be used," the installation has been successful.

## Setting Up the Project

### 1. Initial Setup

First, open the `terraform.tfvars` file and input the necessary values to create your virtual machines.

#### Sample `terraform.tfvars` file:

```hcl
# Path to the cloud-init file for virtual machine configuration
cloud_init_file = "./cloudinit/cloud_init.cfg"

# Type and path for KVM storage configuration
pool_type       = "dir"
libvirt_url     = "qemu:///system"
pool_path       = "/home/user/Volume/kvm"

# Path to the OS image for virtual machines
source_path     = "/home/user/Downloads/noble-server-cloudimg-amd64.img"

# SSH key for accessing the virtual machines
ssh_key         = "ssh_key"

# Virtual Machine definitions
vm_definitions = [
  # Method 1: Define master, worker, loadbalancer VMs
  { type = "master", count = 3, memory = 2048, vcpu = 2, size_disk = 10361393152 },
  { type = "worker", count = 2, memory = 4048, vcpu = 4, size_disk = 10361393152 },
  { type = "loadbalancer", count = 1, memory = 1024, vcpu = 1, size_disk = 10361393152 }
]

# Method 2: Use an alternative definition for virtual machines
vm_definitions_alt = [
  { type = "vm", count = 3, memory = 2048, vcpu = 2, size_disk = 10361393152 }
]
```

### Explanation:

1. **`vm_definitions`**: Here, you can define various types of virtual machines with different specifications (e.g., `master`, `worker`, `loadbalancer`). Each entry in the list includes the machine type (`type`), the number of machines (`count`), memory size (`memory`), number of CPU cores (`vcpu`), and disk size (`size_disk`).

2. **Machine Definition Styles**:
   - **Method 1**: Define specific machine types (e.g., `master`, `worker`, `loadbalancer`) separately with their resources.
   - **Method 2**: You can alternatively use a simpler definition format for machines like `vm`, as shown in `vm_definitions_alt`.
   - You can use whichever method suits your scenario.

### 2. Configuring Terraform

After setting the desired values in the `terraform.tfvars` file, follow these steps:

#### 2.1. Run Terraform Initialization

First, navigate to your project directory and initialize Terraform:
```bash
terraform init
```

#### 2.2. Review the Infrastructure Plan

To verify that everything is correctly configured, check the plan:
```bash
terraform plan
```

#### 2.3. Apply the Changes

Once you confirm the plan, create the infrastructure by running:
```bash
terraform apply
```
This will automatically create the virtual machines as per your configuration.

### 3. Accessing the Virtual Machines

After the virtual machines are created, you can access them using SSH. Use the SSH key defined in the `terraform.tfvars` file to connect to the virtual machines.

```bash
ssh -i path_to_your_ssh_key user@vm_ip
```

## Additional Notes

- **cloud-init**: The `cloud_init.cfg` file used for initial virtual machine configuration should include settings like networking, users, and other OS-level configurations. You can modify this file according to your specific needs.
  
- **Disk Size and Resources**: You can adjust the `memory`, `vcpu`, and `size_disk` values based on your requirements. The size of the disk and the resources (CPU/RAM) should be chosen according to the type of virtual machine and the workload it will handle.

- **Number of Machines**: For each machine type (`master`, `worker`, `loadbalancer`), you can specify the desired number of machines. In the example above, we define 3 `master` machines, 2 `worker` machines, and 1 `loadbalancer`.

## Destroying Infrastructure

To destroy the created infrastructure and clean up the resources, run:

```bash
terraform destroy
```

This command will remove all the virtual machines and resources managed by Terraform.

Support
-------

For support or to report issues, please open a new [**Issue**](https://github.com/nazari-mohsen/terraform/issues) on GitHub Issues.

License
-------

This project is licensed under the Apache-2.0 license.
