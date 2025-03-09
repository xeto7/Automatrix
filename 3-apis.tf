resource "google_project_service" "api" {
  for_each = toset(local.apis)
  service  = each.key

  disable_on_destroy = false

  timeouts {
    create = local.timeouts
  }

  depends_on = [google_project.new_project]
}
