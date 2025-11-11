variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  default     = "b1g1i4af7bothunbpi4u"
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
  default     = "b1gr3bbitfk3mr755b15"
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
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFZ8/AszQy1+2a9noIPmdit1SiFB+d/XVPqboBO+CANULgMq11DVFl8pzacj2zyL3REo3C+7tU/qH5hZrtvMWgouTc0jv+U2HvG/g9zzLwO84ZSTOTzfwdtwv4127AuyjD5YDj8edXaXUNqxOFRUj/DL4uK3UdZ9NgJdNkjyHvg3hZ8r2pxicAUDinj2Sv70J2T4k29lPEkKoVchtIcF/YkFLEx4F6QIT7sDWOtxXbyL/CItquAYQwRgSO3yNuJ4M4DZDHtwmPIRdIHHNlGa6Al0l+Jztqf85Hl8MuYFvmbFufTS8Gp4JHfU436T8F4uGBZA7o8QOdR7WR/g/MxMUsAth2EMrNT7oqbe0CEE+Ru7U9PMzta5Ps1eDOBYTkLwwkVqj6fyvpxdzIcgY8dCK6U2CEgtYFalnuCfauswEQS+4HE8phr8m6Uq1ubIJ8SQkS0G7oKb/r761tXI7pqtJyRf6Ar0RqLEBPcERcpq/TYwcQvmdKHdCSdWLwbl68fMs= artem@deb12-vm3"
}
