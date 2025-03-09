provider "google" {
  project     = local.project_id
  region      = local.region
  credentials = file("~/.config/gcloud/application_default_credentials.json")
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

resource "null_resource" "set_gcloud_project" {
  provisioner "local-exec" {
    command = "gcloud config set project ${local.project_id}"
  }
  triggers = {
    always_run = timestamp()
  }
}
