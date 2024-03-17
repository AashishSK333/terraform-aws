resource "google_compute_network" "auto-vpc-network" {
  name = "auto-vpc-network"
  auto_create_subnetworks = true
}

resource "google_compute_network" "custom-vpc-network" {
  name = "custom-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub-sg" {
  name   = "sub-sg"
  network = google_compute_network.custom-vpc-network.id
  ip_cidr_range = "10.1.0.0/24"
  region = "asia-southeast1"
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow-tcp-icmp" {
    name = "allow-tcp-icmp"
    network = google_compute_network.custom-vpc-network.id
    allow {
      protocol = "tcp"
      ports = [ "20", "80", "443" ]
    }

    allow {
      protocol = "icmp"
    }
    source_ranges = ["0.0.0.0/0"]
  
}
