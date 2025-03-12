![image](https://github.com/mytechnotalent/automatrix/blob/main/Automatrix.png?raw=true)

# Automatrix

Automatrix is a deterministic, infinitely scalable automation framework that fuses Terraform and Ansible to provision, configure, and maintain GCP Free-Tier VMs with absolute precision. Built on immutable infrastructure and idempotent execution, it guarantees every deployment is identical and flawlessly repeatable.

## ✅ Step-by-Step Guide

## 1. Install & Configure Cloud CLI (https://cloud.google.com/sdk/docs/install)
```bash
mv ~/Downloads/google-cloud-cli-darwin-arm.tar.gz .
tar -zxf google-cloud-cli-darwin-arm.tar.gz
rm google-cloud-cli-darwin-arm.tar.gz 
rm ~/google-cloud-sdk
mv google-cloud-sdk ~/
cd ~/google-cloud-sdk 
./install.sh
unset GOOGLE_APPLICATION_CREDENTIALS
gcloud config unset project
gcloud auth application-default revoke
gcloud auth application-default login
ssh-keygen -R free-tier-vm
```

## 2. Install Terraform (https://developer.hashicorp.com/terraform/install?product_intent=terraform)
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

## 3. Configure Terraform
```hcl
locals {
  # gcloud beta billing accounts list
  billing_account = "<billing_account>"
  project_id      = "<project_id>"
  project_name    = "<project_name>"
  region          = "us-central1"
  zone            = "us-central1-a"
  instance_name   = "free-tier-vm"
  machine_type    = "e2-micro"
  image           = "debian-cloud/debian-11"
  disk_size       = 30
  disk_type       = "pd-standard"
  ansible_user    = "<ansible_user>"
  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com",
    "networkmanagement.googleapis.com"
  ]
}
```

## 4. Init, Plan, Apply Terraform
```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply -auto-approve 
```

## 5. Install Ansible
```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install ansible google-auth requests
```

## 6. SSH
```bash
gcloud compute ssh free-tier-vm --zone=us-central1-a --tunnel-through-iap --project=$(terraform output -raw project_id)
```

## 7. Run Entire Ansible Suite
```bash
ansible-playbook site.yaml
```

## 8. Run Individual Ansible Tag 
```bash
ansible-playbook site.yaml --tags "file_analysis"
```

## 9. Run Tests & Review Test Report
```bash
./run_tests.sh
cat report.log
```

## License
[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
