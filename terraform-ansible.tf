resource "google_compute_instance" "ansible" {
  name = "ansible"

  machine_type = "f1-micro"
  tags = [ "ansible" ]

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

resource "null_resource" "installAnsible" {
  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "welli"
        private_key = file("~/.ssh/google_compute_engine")     
        host = google_compute_instance.ansible.network_interface.0.access_config.0.nat_ip   
    }

    inline = [
        "sudo apt-get update",
        "sudo apt-get install -y software-properties-common",
        "sudo apt-add-repository --yes --update ppa:ansible/ansible",
        "sudo apt-get -y install python3 ansible=2.9.18-1ppa~xenial"
    ]
  }

  depends_on = [
    google_compute_instance.ansible
  ]
}

resource "null_resource" "uploadAnsible" {
  provisioner "file" {
    connection {
        type = "ssh"
        user = "welli"
        private_key = file("~/.ssh/google_compute_engine")     
        host = google_compute_instance.ansible.network_interface.0.access_config.0.nat_ip   
    }

    source = "ansible"
    destination = "/home/welli"
  }

  depends_on = [
    null_resource.installAnsible
  ]
}

resource "null_resource" "ExecuteAnsible" {
  provisioner "remote-exec" {
    connection {
        type = "ssh"
        user = "welli"
        private_key = file("~/.ssh/google_compute_engine")     
        host = google_compute_instance.ansible.network_interface.0.access_config.0.nat_ip   
    }

    inline = [
        "ansible-playbook -i /home/welli/ansible/hosts /home/welli/ansible/main.yml"
    ]
  }

  depends_on = [
    null_resource.uploadAnsible
  ]
}

