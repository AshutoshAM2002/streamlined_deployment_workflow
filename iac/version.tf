terraform {
  backend "gcs" {
    bucket = "iac-tfstate-backup-store"
    prefix = "terraform/state"
  }
  required_version = "1.3.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.75"
    }
  }
}

