resource "google_project" "new_project" {
  project_id      = local.project_id
  name            = local.project_name
  billing_account = local.billing_account
}
