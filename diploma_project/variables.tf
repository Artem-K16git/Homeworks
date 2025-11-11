variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  default     = "your_yc_cloud_id"
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
  default     = "your_yc_folder_id"
}

variable "vm_username" {
  type        = string
  description = "Username for VM access"
  default     = "test-net"
}

locals {
  zones = ["ru-central1-a", "ru-central1-b"]
}

variable "vm_image_id" {
  type        = string
  description = "ID образа OS в Yandex Cloud"
  default     = "fd806q5trjs2iufisdm1"
}

variable "ansible_ssh_private_key_file" {
  type        = string
  description = "Путь к приватному ключу для Ansible (на управляющем узле)"
  default     = "~/.ssh/id_rsa"
}

variable "ssh_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "your_ssh-key.pub"
}
