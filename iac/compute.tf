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
    network    = google_compute_network.main.id
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
    network    = google_compute_network.main.id
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
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
}
resource "google_compute_instance" "k8s_slave" {
  name         = "k8s-slave"
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
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
}

resource "google_compute_instance" "nexus-server" {
  name         = "nexus-server"
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
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.private.id
    access_config {
      network_tier = "PREMIUM"
    }
  }
}

#resource "google_container_cluster" "primary" {
#  name                     = "k8s-master"
#  location                 = "asia-south1"
#  remove_default_node_pool = true
#  initial_node_count       = 1
#  network                  = google_compute_network.main.self_link
#  subnetwork               = google_compute_subnetwork.private.self_link
#  #logging_service          = "logging.googleapis.com/kubernetes"
#  #monitoring_service       = "monitoring.googleapis.com/kubernetes"
#  networking_mode          = "VPC_NATIVE"
#
#  # Optional, if you want multi-zonal cluster
#  node_locations = [
#    "asia-south1-c"
#  ]
#
#  addons_config {
#    http_load_balancing {
#      disabled = true
#    }
#    horizontal_pod_autoscaling {
#      disabled = false
#    }
#  }
#
#  release_channel {
#    channel = "REGULAR"
#  }
#
#  workload_identity_config {
#    identity_namespace = "phonic-heaven-380313.svc.id.goog"
#    #workload_pool      = "phonic-heaven-380313.svc.id.goog"
#  }
#
#  ip_allocation_policy {
#    cluster_secondary_range_name  = "k8s-pod-range"
#    services_secondary_range_name = "k8s-service-range"
#  }
#
##  private_cluster_config {
##    enable_private_nodes    = true
##    enable_private_endpoint = false
##    master_ipv4_cidr_block  = "172.16.0.0/28"
##  }
#
#  master_authorized_networks_config {
#    cidr_blocks {
#      cidr_block   = "10.0.0.0/18"
#      display_name = "private-subnet-w-jenkins"
#    }
#  }
#}
#
#resource "google_service_account" "kubernetes" {
#  account_id = "kubernetes"
#}
#
## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
#resource "google_container_node_pool" "general" {
#  name       = "general"
#  cluster    = google_container_cluster.primary.id
#  node_count = 1
#
#  management {
#    auto_repair  = true
#    auto_upgrade = true
#  }
#
#  node_config {
#    preemptible  = false
#    machine_type = "e2-small"
#
#    labels = {
#      role = "general"
#    }
#
#    service_account = google_service_account.kubernetes.email
#    oauth_scopes = [
#      "https://www.googleapis.com/auth/cloud-platform"
#    ]
#  }
#}
#
#resource "google_container_node_pool" "spot" {
#  name    = "spot"
#  cluster = google_container_cluster.primary.id
#
#  management {
#    auto_repair  = true
#    auto_upgrade = true
#  }
#
#  autoscaling {
#    min_node_count = 0
#    max_node_count = 10
#  }
#
#  node_config {
#    preemptible  = true
#    machine_type = "e2-small"
#
#    labels = {
#      team = "devops"
#    }
#
#    taint {
#      key    = "instance_type"
#      value  = "spot"
#      effect = "NO_SCHEDULE"
#    }
#
#    service_account = google_service_account.kubernetes.email
#    oauth_scopes = [
#      "https://www.googleapis.com/auth/cloud-platform"
#    ]
#  }
#}


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



