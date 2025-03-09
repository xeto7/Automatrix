resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
  project      = google_project.new_project.project_id
}

resource "google_project_iam_member" "compute_admin" {
  project = google_project.new_project.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

resource "google_project_iam_member" "compute_viewer" {
  project = google_project.new_project.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

resource "google_project_iam_member" "sa_user" {
  project = google_project.new_project.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}