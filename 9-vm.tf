resource "google_compute_instance" "free_vm" {
  name         = local.instance_name
  machine_type = local.machine_type
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = local.image
      size  = local.disk_size
      type  = local.disk_type
    }
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.public.self_link

    access_config {} # This automatically assigns an external IP
  }

  metadata_startup_script = <<EOT
#!/bin/bash
echo "Hello from Terraform Free Tier VM!" > /home/${local.ansible_user}/welcome.txt
EOT

  tags = ["http-server", "https-server"]

  service_account {
    email  = google_service_account.terraform_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.public,
    google_compute_subnetwork.private,
    google_service_account.terraform_sa
  ]
}
