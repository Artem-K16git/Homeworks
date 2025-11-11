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
    preemptible = true
  }
}

# Web Servers
resource "yandex_compute_instance" "vm" {
  count       = 2
  name        = "web-server-${count.index + 1}"
  hostname    = "web-server-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = local.zones[count.index]

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
    subnet_id = yandex_vpc_subnet.web_subnets[count.index].id
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
    preemptible = true  
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
      size     = 15  # 15 ГБ HDD
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
    preemptible = true 
  }
}


resource "local_file" "inventory" {
  content = <<-EOT
    [bastion]
    ${yandex_compute_instance.bastion.network_interface.0.nat_ip_address} ansible_user=${var.vm_username}

    [zabbix_server]
    ${yandex_compute_instance.zabbix.network_interface.0.ip_address} ansible_user=${var.vm_username}

    [elasticsearch]
    ${yandex_compute_instance.elasticsearch.network_interface.0.ip_address} ansible_user=${var.vm_username}

    [kibana]
    ${yandex_compute_instance.kibana.network_interface.0.ip_address} ansible_user=${var.vm_username}

    [webservers]
    %{ for idx, vm in yandex_compute_instance.vm ~}
    ${vm.fqdn} ansible_host=${vm.fqdn} ansible_user=${var.vm_username}
    %{ endfor ~}

    # Группа для хостов, доступных через бастион
    [via_bastion:children]
    zabbix_server
    webservers
    elasticsearch
    kibana

    [via_bastion:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -J ${var.vm_username}@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}'

    [elk_stack:children]
    elasticsearch
    kibana

  EOT
  filename = "./ansible/inventory/hosts.ini"
}
