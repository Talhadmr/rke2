# src/main.tf

##############################################################
# PROVIDERS & TERRAFORM SETTINGS
##############################################################
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

##############################################################
# RANDOM TOKEN (RKE2 CLUSTER TOKEN)
##############################################################
resource "random_password" "rke2_cluster_token" {
  length  = 16
  special = false
}

##############################################################
# NETWORK & FIREWALL
##############################################################
resource "google_compute_network" "rke2_network" {
  name                    = "rke2-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "rke2_firewall" {
  name    = "rke2-firewall"
  network = google_compute_network.rke2_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "6443", "9345", "2379-2380", "10250", "10257", "10259"]
  }

  source_ranges = ["0.0.0.0/0"]
}

##############################################################
# MANAGER INSTANCES
##############################################################
resource "google_compute_instance" "manager" {
  count        = var.manager_count
  name         = "rke2-manager-${count.index}"
  machine_type = var.machine_type
  tags         = ["rke2-node", "rke2-manager"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20
    }
  }

  network_interface {
    network = google_compute_network.rke2_network.self_link
    access_config {}
  }

  metadata_startup_script = file("${path.module}/../scripts/rke2_manager.sh")

  metadata = {
    RKE2_CLUSTER_TOKEN = random_password.rke2_cluster_token.result
  }

  service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }
}

##############################################################
# WORKER INSTANCES
##############################################################
resource "google_compute_instance" "worker" {
  count        = var.worker_count
  name         = "rke2-worker-${count.index}"
  machine_type = var.machine_type
  tags         = ["rke2-node", "rke2-worker"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20
    }
  }

  network_interface {
    network = google_compute_network.rke2_network.self_link
    access_config {}
  }

  metadata_startup_script = file("${path.module}/../scripts/rke2_worker.sh")

  metadata = {
    RKE2_SERVER_IP     = element(google_compute_instance.manager[*].network_interface[0].network_ip, 0)
    RKE2_CLUSTER_TOKEN = random_password.rke2_cluster_token.result
  }

  service_account {
    email  = "default"
    scopes = ["cloud-platform"]
  }
}
