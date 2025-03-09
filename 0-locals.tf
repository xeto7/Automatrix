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
  timeouts        = "10m"
  ansible_user    = "<ansible_user>"
  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "secretmanager.googleapis.com",
    "networkmanagement.googleapis.com"
  ]
}
