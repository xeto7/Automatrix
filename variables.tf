variable "gcp_project" {
  description = "Your GCP project ID"
  type        = string
}

variable "gcp_zone" {
  description = "GCP Compute zone for your VM"
  type        = string
  default     = "us-central1-a"
}

variable "credentials_file" {
  description = "Path to GCP JSON credentials file"
  type        = string
  default     = "~/.gcp/terraform-key.json"
}
