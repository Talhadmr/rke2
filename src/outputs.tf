# src/outputs.tf

output "manager_public_ips" {
  description = "Public IP addresses of manager nodes"
  value       = [for i in google_compute_instance.manager : i.network_interface[0].access_config[0].nat_ip]
}

output "worker_public_ips" {
  description = "Public IP addresses of worker nodes"
  value       = [for i in google_compute_instance.worker : i.network_interface[0].access_config[0].nat_ip]
}
