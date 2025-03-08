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
      size = 30
      type = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Public IP
    }
  }
}
