# Terraform KVM Infrastructure

This project uses **Terraform** and **KVM** (Kernel-based Virtual Machine) to create various infrastructure scenarios. You simply need to provide the necessary values in the `terraform.tfvars` file and then run Terraform to set up your virtual machines.

## **Prerequisites**

Before starting, ensure that the following are installed on your system:

- **Terraform**: for infrastructure management as code.
- **KVM**: for creating and managing virtual machines.
- **libvirt**: for interacting with KVM.

### **Installing Prerequisites on Ubuntu**

#### 1. Install Terraform

To install **Terraform** on Ubuntu, first download the appropriate version for your system:

1. Update and install dependencies:
   ```bash
   sudo apt-get update && sudo apt-get install -y wget unzip
   ```

2. Download and install Terraform:
   ```bash
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

2. Ensure that the `libvirt` service is running:
   ```bash
   sudo systemctl enable libvirtd
   sudo systemctl start libvirtd
   ```

3. Make sure your user is added to the `libvirt` group:
   ```bash
   sudo usermod -aG libvirt $(whoami)
   ```

4. To verify that KVM is installed successfully, run:
   ```bash
   kvm-ok
   ```

   If the result is "KVM acceleration can be used," the installation was successful.

## **Setting Up the Project**

### 1. Cloning the Project and Navigating to the KVM Directory

To get started, clone the project from GitHub and navigate to the project directory.

#### 1.1. Clone the Project from GitHub

To clone the project, use the following command:

```bash
git clone https://github.com/nazari-mohsen/terraform.git
```

(Replace `username` with the actual username of the repository owner.)

#### 1.2. Navigate to the Project Directory

After cloning, go into the project directory:

```bash
cd kvm
```

#### **Steps to Configure the `terraform.tfvars` File:**

1. Copy the file `terraform.tfvars.sample` from the `sample` directory.
2. Paste it in the `kvm` directory and rename it as `terraform.tfvars`.
3. Update the values in the `terraform.tfvars` file to reflect your own configuration (such as paths, SSH keys, VM specifications, etc.).

#### **Default OS Image:**

By default, the OS image used is the `noble-server-cloudimg-arm64.img` image from:

[Ubuntu Cloud Images](https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img)

You can download this image and place it in your desired directory. After downloading, update the `source_path` variable in the `terraform.tfvars` file to point to the location where you saved the image.

### 2. Configure the `terraform.tfvars` File

Once you're in the project directory, create the `terraform.tfvars` file and enter the necessary values to configure your virtual machines.

#### Sample `terraform.tfvars` File:

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

### 3. Running Terraform

Once the values are configured in the `terraform.tfvars` file, follow these steps to run Terraform:

#### 3.1. Initialize Terraform

First, initialize Terraform:

```bash
terraform init
```

#### 3.2. Review the Infrastructure Plan

To check if everything is configured correctly, run the following command to review the infrastructure plan:

```bash
terraform plan
```

#### 3.3. Apply the Changes

After confirming the plan, run the following command to create the virtual machines and infrastructure:

```bash
terraform apply
```

This will automatically create the virtual machines based on the configuration in the `terraform.tfvars` file.

### 4. Accessing the Virtual Machines

After the virtual machines are created, you can access them via SSH. Use the SSH key defined in the `terraform.tfvars` file to connect to the virtual machines.

```bash
ssh -i path_to_your_ssh_key user@vm_ip
```

### 5. Destroying Infrastructure

If you wish to remove the created infrastructure, use the following command:

```bash
terraform destroy
```

This will delete all the virtual machines and resources managed by Terraform.

## **Additional Notes**

- **cloud-init**: The `cloud_init.cfg` file is used for initial virtual machine configuration (e.g., networking, users, and other OS-level settings). You can modify this file as per your requirements.

- **Disk Size and Resources**: You can adjust the `memory`, `vcpu`, and `size_disk` values based on your needs. The disk size and resources (CPU/RAM) should be chosen according to the type of virtual machine and the workload it will handle.

- **Number of Machines**: For each machine type (`master`, `worker`, `loadbalancer`), you can specify the desired number of machines. In the example above, we define 3 `master` machines, 2 `worker` machines, and 1 `loadbalancer`.

## **Support**

For support or to report issues, please open a new [**Issue**](https://github.com/nazari-mohsen/terraform/issues) on GitHub Issues.

## **License**

This project is licensed under the Apache-2.0 license.