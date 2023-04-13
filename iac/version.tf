terraform {
  backend "gcs" {
    bucket = "iac-tfstate-backup-store"
    prefix = "terraform/state"
  }
  required_version = "1.4.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.75"
    }
  }
}

