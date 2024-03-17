resource "google_pubsub_topic" "terraform-pubsub" {
  name = "terraform-pubsub"
}

resource "google_pubsub_subscription" "terraform-pubsub-subscription" {
  name = "terraform-sub"
  topic = google_pubsub_topic.terraform-pubsub.name
  depends_on = [ google_pubsub_topic.terraform-pubsub ]
}