output "gcp-vm-terraform" {
  value = google_compute_instance.gcp-instance2.name
}
/*
output "custom-vpc-network" {
    value = google_compute_network.custom-vpc-network.id
}
*/