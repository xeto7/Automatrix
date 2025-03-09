output "project_id" {
  value = google_project.new_project.project_id
}

output "vm_public_ip" {
  value = google_compute_instance.free_vm.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  value = "gcloud compute ssh ${local.instance_name} --zone=${local.zone} --project=${google_project.new_project.project_id}"
}

output "ansible_inventory" {
  value = <<EOT
[gcp]
${local.instance_name} ansible_host=${local.instance_name} ansible_user=${local.ansible_user} ansible_ssh_private_key_file=~/.ssh/google_compute_engine ansible_ssh_common_args="-o ProxyCommand='gcloud compute start-iap-tunnel ${local.instance_name} 22 --listen-on-stdin --project=${google_project.new_project.project_id} --zone=${local.zone}'"
EOT
}
