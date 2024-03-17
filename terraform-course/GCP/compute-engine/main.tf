resource "google_compute_instance" "gcp-instance1" {
  name = "gcp-instance-terraform"

  zone = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size = 20
    }
  }

  machine_type = "e2-micro"

  network_interface {
    network = "custom-vpc-network"
    subnetwork = "sub-sg"
  }
  
}

resource "google_compute_instance" "gcp-instance2" {
  name = "gcp-instance-terraform2"

  zone = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size = 20
    }
  }

  machine_type = "e2-micro"
  
  tags = [ "web", "dev" ]
  
  network_interface {
    network = "custom-vpc-network"
    subnetwork = "sub-sg"
  }  
}