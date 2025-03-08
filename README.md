![image](https://github.com/mytechnotalent/ansible-gcp-free-tier-vm/blob/main/terraform-ansible-gcp-free-tier-vm.png?raw=true)

# Terraform + Ansible GCP Free-Tier VM

This repository contains a **Terraform script** for provisioning a Google Cloud Platform (GCP) free-tier VM and an **Ansible playbook** for post-deployment configuration.

## 📌 Prerequisites

- **Google Cloud account**: [console.cloud.google.com](https://console.cloud.google.com)
- **Google Cloud SDK (`gcloud`)**
- **Terraform**
- **Python 3, pip, and Ansible**
- **Basic YAML & Terraform understanding**

## ✅ Step-by-Step Guide

### 1. Set Up GCP Project & IAM

#### **Create a GCP Project**
1. Log in at [console.cloud.google.com](https://console.cloud.google.com).
2. Click **New Project**, name it, and copy your **Project ID**.

#### **Enable Compute Engine API**
- Visit:  
  https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=\<your-gcp-project-id\>  
- Click **ENABLE**.

#### **Create a Service Account**
1. Navigate to **IAM & Admin → Service Accounts**.
2. Click **+ CREATE SERVICE ACCOUNT**.
3. Name it **terraform-sa**.
4. Click **DONE**.

#### **Generate JSON Key for the Service Account**
1. Select your new service account.
2. Click **KEYS → ADD KEY → Create new key → JSON → CREATE**.
3. Store the downloaded file at:  
   `~/.gcp/terraform-key.json`

#### **Assign IAM Roles to Service Account**
1. Go to **IAM → GRANT ACCESS**.
2. Click **New principals** and paste your **service account email**.
3. Assign the following roles:
   - **Compute Admin**
   - **Compute Viewer**
   - **Service Account User**
4. Click **SAVE**.

### 2. Install Dependencies

#### **Install Google Cloud SDK, Terraform, and Ansible**
Run the following:
```bash
curl -sSL https://sdk.cloud.google.com | bash  
exec -l $SHELL  
gcloud init  
brew tap hashicorp/tap  
brew install terraform  
python3 -m venv venv  
source venv/bin/activate  
pip install requests ansible google-auth  
```

### 3. Create Terraform Configuration

#### **Terraform Configuration Files**

#### **`variables.tf`**
```tf
variable "gcp_project" {  
  description = "Your GCP project ID"  
  type        = string  
}

variable "gcp_zone" {  
  description = "Compute Engine zone"  
  type        = string  
  default     = "us-central1-a"  
}  

variable "credentials_file" {  
  description = "Path to GCP JSON credentials"  
  type        = string  
  default     = "~/.gcp/terraform-key.json"  
}  
```

#### **`terraform.tfvars`**
```tf
gcp_project      = "<your-gcp-project-id>"  
gcp_zone         = "us-central1-a"  
credentials_file = "~/.gcp/terraform-key.json"  
```

#### **`main.tf`**
```tf
provider "google" {  
  project     = var.gcp_project  
  region      = "us-central1"  
  zone        = var.gcp_zone  
  credentials = file(var.credentials_file)  
}  

resource "google_compute_instance" "ansible_free_vm" {  
  name         = "ansible-free-vm"  
  machine_type = "e2-micro"  

  boot_disk {  
    initialize_params {  
      image = "debian-cloud/debian-11"  
      size  = 30  
      type  = "pd-standard"  
    }  
  }  

  network_interface {  
    network = "default"  
    access_config {}  
  }  
}  
```

#### **`outputs.tf`**
```tf
output "vm_public_ip" {  
  value = google_compute_instance.ansible_free_vm.network_interface[0].access_config[0].nat_ip  
}  
```

### **Run Terraform**
```bash
terraform init  
terraform plan  
terraform apply  
```

Terraform will output the **VM’s public IP**.

### 4. Configure the VM with Ansible

#### **`inventory.ini`**
```ini
[gcp]  
ansible-free-vm ansible_host=<ansible_host> ansible_user=<ansible_user> ansible_ssh_private_key_file=~/.ssh/google_compute_engine
```

- Replace `<ansible_host>` with the IP Terraform outputted.  
- Replace `<ansible_user>` (typically `debian`, `ubuntu`, or `root`).  

### **Create an Ansible Playbook (`configure_vm.yaml`)**
```yaml
- name: Configure GCP VM  
  hosts: gcp  
  tasks:  

    - name: Create a test directory  
      file:  
        path: ~/test  
        state: directory  
        mode: '0755'  
```

### **Run the Playbook**
```bash
ansible-playbook -i inventory.ini configure_vm.yaml  
```

## 5. SSH into Your VM
```bash
gcloud compute ssh ansible-free-vm --zone=us-central1-a --project=<your-gcp-project-id>  
```

or using regular SSH:  

```bash
ssh -i ~/.ssh/google_compute_engine <ansible_user>@<ansible_host>  
```

## 🎯 Optional Clean-up

### **Delete VM**
```bash
terraform destroy  
```

🎉 **Now you have a Terraform + Ansible automation workflow for GCP!** 🚀

## License
[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
