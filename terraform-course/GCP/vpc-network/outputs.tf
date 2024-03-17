output "auto-vpc-network" {
  value = google_compute_network.auto-vpc-network.id
}

output "custom-vpc-network" {
    value = google_compute_network.custom-vpc-network.id
}