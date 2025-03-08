![image](https://github.com/mytechnotalent/ansible-gcp-free-tier-vm/blob/main/ansible-gcp-free-tier-vm.png?raw=true)

# Ansible GCP Free-Tier VM

This repository contains an Ansible playbook and detailed instructions for provisioning a Google Cloud Platform (GCP) free-tier VM instance using Ansible automation.

---

## 📌 Prerequisites

- Google Cloud account: [console.cloud.google.com](https://console.cloud.google.com)
- Google Cloud SDK (`gcloud`)
- Python 3 and pip
- Ansible
- Basic YAML understanding

---

## ✅ Step-by-Step Guide

## 1. Create a GCP Project

Log in at [console.cloud.google.com](https://console.cloud.google.com).

- Click the **project drop-down** and select **"New Project"**.
- Give your project a name and copy your **Project ID**.

## 2. Create a Service Account

- Go to **IAM & Admin → Service Accounts**.
- Click **+ CREATE SERVICE ACCOUNT**.
- Name the account (e.g., `ansible-gcp-sa`).
- Click **DONE**

## 3. Generate JSON Credentials for Service Account

- Select your new service account.
- Click **KEYS → ADD KEY → Create new key → JSON → CREATE**.
- Store the downloaded file at:
  `~/.gcp/ansible-key.json`

## 4. Add IAM Roles

- Click **Service Accounts** and click the `Copy to clipboard` button next to your account.
- Click **IAM → GRANT ACCESS → Add principals → New principals**.
- Paste account into field.
- Under **Assign roles → + ADD ANOTHER ROLE → Select a role → Filter Compute Instance Admin (beta) → + ADD ANOTHER ROLE → Select a role → Filter Compute Viewer → SAVE**

## 5. Enable the Compute Engine API

Before creating a VM, enable Compute Engine API. Visit this link (replace with your Project ID):

https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=\<your-gcp-project-id\>

## 6. Install Dependencies & GCloud Init

Activate your Python environment, install dependencies and init GCloud:
```bash
python3 -m venv venv
source venv/bin/activate
pip install requests ansible google-auth
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

## 7. Create the Ansible Playbook

Create `gcp_vm.yaml` with the following content:
```yaml
- name: Create a GCP Free Tier VM
  hosts: localhost
  gather_facts: no
  vars:
    gcp_project: "<your-gcp-project-id>"
    gcp_zone: "us-central1-a"
    machine_type: "e2-micro"
    disk_size: 30
    disk_type: "pd-standard"
    service_account_file: "~/.gcp/ansible-key.json"
    network_name: "default"

  tasks:
    - name: Create VM instance
      google.cloud.gcp_compute_instance:
        name: ansible-free-vm
        machine_type: "{{ machine_type }}"
        zone: "{{ gcp_zone }}"
        project: "{{ gcp_project }}"
        auth_kind: serviceaccount
        service_account_file: "{{ service_account_file }}"
        disks:
          - auto_delete: true
            boot: true
            initialize_params:
              source_image: "projects/debian-cloud/global/images/family/debian-11"
              disk_size_gb: "{{ disk_size }}"
              disk_type: "{{ disk_type }}"
        network_interfaces:
          - network:
              name: "{{ network_name }}"
            access_configs:
              - name: External NAT
                type: ONE_TO_ONE_NAT
      register: vm_instance

    - name: Display VM details
      debug:
        var: vm_instance
```
Replace `"<your-gcp-project-id>"` with your actual GCP project ID.

## 8. Run the Ansible Playbook

Run the playbook with this command:
```bash
ansible-playbook gcp_vm.yaml
```

## 9. SSH into Your New VM

Use the following command to connect via SSH:
```bash
gcloud config set project <your-gcp-project-id>
gcloud compute ssh ansible-free-vm --zone=us-central1-a --project=<your-gcp-project-id>
```
Replace `<your-gcp-project-id>` accordingly.

---

## 🎯 Optional Clean-up

To avoid costs, delete the VM when done:
```bash
gcloud compute instances delete ansible-free-vm --zone=us-central1-a --project=<your-gcp-project-id>
```

---

🎉 You're all set! You've successfully automated VM creation on Google Cloud with Ansible!

---

## License
[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
