terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  cloud_id      = var.yc_cloud_id
  folder_id     = var.yc_folder_id
  service_account_key_file = file("~/.authorized_key.json")
  zone = "ru-central1-a"
}

