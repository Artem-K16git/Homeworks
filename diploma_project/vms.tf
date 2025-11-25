# Service Account для Instance Group
resource "yandex_iam_service_account" "ig_service_account" {
  name        = "ig-service-account"
  description = "Service account for instance group"
}

resource "yandex_resourcemanager_folder_iam_member" "network_user" {
  folder_id = var.yc_folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.ig_service_account.id}"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ig_service_account.id}"
}

# SSH Bastion
resource "yandex_compute_instance" "bastion" {
  name        = "bastion-host"
  hostname    = "bastion-host"
  platform_id = "standard-v3"
  zone        = local.zones[0]

  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bastion_subnet.id
    ip_address = "10.130.10.10"
    nat       = true
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init-bastion.tpl", {
      ssh_public_key = var.ssh_public_key
      vm_username    = var.vm_username
    })
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = false
  }
}

# Instance Group для веб-серверов
resource "yandex_compute_instance_group" "web_servers" {
  name               = "web-servers-ig"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.ig_service_account.id

  instance_template {
    platform_id = "standard-v3"
    name        = "web-{instance.index}"
    
    resources {
      cores  = 2
      memory = 2
      core_fraction = 20
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.vm_image_id
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.main.id
      subnet_ids = [for subnet in yandex_vpc_subnet.web_subnets : subnet.id]
      nat       = false
      security_group_ids = [yandex_vpc_security_group.web_sg.id]
    }

    metadata = {
      user-data = templatefile("${path.module}/cloud-init-web.tpl", {
        ssh_public_key = var.ssh_public_key
        vm_username    = var.vm_username
      })
      serial-port-enable = 1
    }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = 2  # Минимальное количество ВМ
    }
  }

  allocation_policy {
    zones = local.zones
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }
  
  timeouts {
    create = "20m"
    update = "15m" 
    delete = "15m"
  }

  # Health checks для автоматического восстановления
  health_check {
    interval = 30
    timeout  = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    
    tcp_options {
      port = 80
    }
  }
}

# Zabbix Server
resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix-server"
  hostname    = "zabbix-server"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  allow_stopping_for_update = true

  resources {
    cores  = 2    
    memory = 2    
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = 15    
      type     = "network-hdd"  
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.zabbix_subnet.id
    ip_address = "10.130.2.100"
    nat       = true
    security_group_ids = [yandex_vpc_security_group.zabbix_sg.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init-zabbix.tpl", {
      ssh_public_key = var.ssh_public_key
      vm_username    = var.vm_username
    })
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = false
  }
}

# Elasticsearch Server
resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch-server"
  hostname    = "elasticsearch-server"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 4  
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = 20  
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.web_subnets[0].id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.elasticsearch_sg.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init-elasticsearch.tpl", {
      ssh_public_key = var.ssh_public_key
      vm_username    = var.vm_username
      hostname       = "elasticsearch-server"
    })
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = false 
  }
}

# Kibana Server
resource "yandex_compute_instance" "kibana" {
  name        = "kibana-server"
  hostname    = "kibana-server"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2  
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = 15
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.kibana_subnet.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana_sg.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init-kibana.tpl", {
      ssh_public_key    = var.ssh_public_key
      vm_username       = var.vm_username
      hostname          = "kibana-server"
      elasticsearch_ip  = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
    })
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = false
  }
}

# Ansible inventory
resource "local_file" "inventory" {
  content = <<-EOT
    [bastion]
    ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} ansible_user=${var.vm_username}

    [elasticsearch]
    elasticsearch ansible_host=${yandex_compute_instance.elasticsearch.fqdn} ansible_user=${var.vm_username}

    [kibana]
    kibana ansible_host=${yandex_compute_instance.kibana.fqdn} ansible_user=${var.vm_username}

    [zabbix_server]
    zabbix-server ansible_host=${yandex_compute_instance.zabbix.fqdn} ansible_user=${var.vm_username}

    [webservers]
    %{ for instance in yandex_compute_instance_group.web_servers.instances ~}
    ${instance.name} ansible_host=${instance.fqdn} ansible_user=${var.vm_username}
    %{ endfor ~}

    # Группа для хостов, доступных через бастион
    [via_bastion:children]
    webservers
    elasticsearch
    kibana
    zabbix_server

    [via_bastion:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -J ${var.vm_username}@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}'
    ansible_become=yes
    ansible_become_method=sudo
    ansible_become_user=root

    [elk:children]
    elasticsearch
    kibana

    [monitoring:children]
    zabbix_server

    # Глобальные переменные
    [all:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
    elasticsearch_host=${yandex_compute_instance.elasticsearch.fqdn}
    kibana_host=${yandex_compute_instance.kibana.fqdn}
    zabbix_server_host=${yandex_compute_instance.zabbix.fqdn}

  EOT
  filename = "./ansible/inventory/hosts.ini"
}
