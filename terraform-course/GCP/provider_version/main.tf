terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.15.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "terraform-413703"
  region = "us-east1"
  zone = "us-east1-d"

  credentials = "keys.json"
}

resource "google_storage_bucket" "bucket-for-terraform2" {
  name = "bucket-for-terraform2"
  location = "US"

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "storage-bucket" {
  name = "butterfly"
  source = "Krishna.png"
  bucket = google_storage_bucket.bucket-for-terraform2.name
}
