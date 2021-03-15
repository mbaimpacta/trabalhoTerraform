resource "google_compute_firewall" "default" {
  name = "teste-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}