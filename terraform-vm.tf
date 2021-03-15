resource "google_compute_instance" "mysql" {
  name = "mysql"
  
  machine_type = "f1-micro"
  tags = [ "mysql" ]

  boot_disk {
    initialize_params {
        image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    
    access_config {

    }
  }  
}