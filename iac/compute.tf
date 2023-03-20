resource "google_compute_instance" "jenkins_server" {
  name         = "jenkins-server"
  zone         = "asia-south1-c"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  network_interface {
    network = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
}

resource "google_compute_instance" "sonarqube_server" {
  name         = "sonarqube-server"
  zone         = "asia-south1-c"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  network_interface {
    network = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
}

resource "google_compute_instance" "k8s-server" {
  name         = "k8s-server"
  zone         = "asia-south1-c"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  network_interface {
    network = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
}


/**************************************
Static ip address for compute instances
***************************************/

#resource "google_compute_address" "jenkins_ip" {
#  name         = "jenkins-ip"
#  address_type = "EXTERNAL"
#  subnetwork = google_compute_subnetwork.private.self_link
#}
#
#resource "google_compute_address" "sonarqube_ip" {
#  name         = "sonarqube-ip"
#  address_type = "EXTERNAL"
#  subnetwork = google_compute_subnetwork.private.self_link
#}
#
#resource "google_compute_address" "k8s_ip" {
#  name         = "k8s-ip"
#  address_type = "EXTERNAL"
#  subnetwork = google_compute_subnetwork.private.self_link
#}



