resource "local_file" "ansible_inventory" {
  filename = "inventory.ini"
  content  = <<EOT
[gcp]
${local.instance_name} ansible_host=${local.instance_name} ansible_user=${local.ansible_user} ansible_ssh_private_key_file=~/.ssh/google_compute_engine ansible_ssh_common_args="-o ProxyCommand='gcloud compute start-iap-tunnel ${local.instance_name} 22 --listen-on-stdin --project=${google_project.new_project.project_id} --zone=${local.zone}'"
EOT
}
