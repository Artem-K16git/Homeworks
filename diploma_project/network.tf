# Создание облачной сети
resource "yandex_vpc_network" "main" {
  name = "main-network"
}

# Подсеть для бастиона
resource "yandex_vpc_subnet" "bastion_subnet" {
  name           = "bastion-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.130.10.0/24"]
}

# Таблица маршрутов для веб-серверов (создаем ПЕРВОЙ)
resource "yandex_vpc_route_table" "nat_route" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "10.130.10.10"  # Фиксированный IP бастиона
  }
}

# Подсети веб-серверов с привязкой таблицы маршрутов
resource "yandex_vpc_subnet" "web_subnets" {
  count          = 2
  name           = "web-subnet-${count.index == 0 ? "a" : "b"}"
  zone           = count.index == 0 ? "ru-central1-a" : "ru-central1-b"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [count.index == 0 ? "10.130.0.0/24" : "10.130.1.0/24"]
  route_table_id = yandex_vpc_route_table.nat_route.id  # Привязываем таблицу маршрутов
}

# Подсеть для Zabbix‑сервера (без route_table_id для прямого доступа в интернет)
resource "yandex_vpc_subnet" "zabbix_subnet" {
  name         = "zabbix-subnet"
  zone         = "ru-central1-a"
  network_id   = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.130.2.0/24"]
}

# Подсеть для Kibana (без route_table_id для прямого доступа в интернет)
resource "yandex_vpc_subnet" "kibana_subnet" {
  name           = "kibana-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.130.3.0/24"]
}
# Группа безопасности для веб-серверов
resource "yandex_vpc_security_group" "web_sg" {
  name        = "web-security-group"
  network_id  = yandex_vpc_network.main.id
  description = "Security group for web servers"

  depends_on = [yandex_vpc_subnet.web_subnets]  # Зависимость от подсетей

  ingress {
    protocol       = "TCP"
    description    = "SSH from bastion subnet"
    port           = 22
    v4_cidr_blocks = ["10.130.10.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "from Zabbix-server"
    port           = 10050
    v4_cidr_blocks = ["10.130.2.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP from anywhere"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS from anywhere"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic for updates"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Группа безопасности для бастиона
resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  network_id  = yandex_vpc_network.main.id
  
  ingress {
    protocol       = "TCP"
    description    = "SSH from internet"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ANY"
    description    = "Traffic from web servers for NAT"
    v4_cidr_blocks = ["10.130.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Группа безопасности для Zabbix
resource "yandex_vpc_security_group" "zabbix_sg" {
  name        = "zabbix-security-group"
  network_id  = yandex_vpc_network.main.id
  
  # SSH из подсети бастиона
  ingress {
    protocol       = "TCP"
    description    = "SSH from bastion subnet"
    port           = 22
    v4_cidr_blocks = ["10.130.10.0/24"]
  }

  # Zabbix web interface из интернета(HTTP)
  ingress {
    protocol       = "TCP"
    description    = "Zabbix web interface"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Zabbix web interface из интернета(HTTPS)
  ingress {
    protocol       = "TCP"
    description    = "Zabbix web interface"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Zabbix server port для агентов
  ingress {
    protocol       = "TCP"
    description    = "Zabbix server for agents"
    port           = 10051
    v4_cidr_blocks = ["10.130.0.0/16"]
  }

  # Исходящий трафик
  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Группа безопасности для Kibana
resource "yandex_vpc_security_group" "kibana_sg" {
  name        = "kibana-security-group"
  network_id  = yandex_vpc_network.main.id
  description = "Security group for Kibana"

  ingress {
    protocol       = "TCP"
    description    = "SSH from bastion subnet"
    port           = 22
    v4_cidr_blocks = ["10.130.10.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Kibana web interface from anywhere"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP from anywhere"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS from anywhere"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "from Zabbix-server"
    port           = 10050
    v4_cidr_blocks = ["10.130.2.0/24"]
  }

  egress {
    protocol       = "TCP"
    description    = "Access to Elasticsearch"
    port           = 9200
    v4_cidr_blocks = ["10.130.0.0/24"]  # Подсеть где находится Elasticsearch
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic to internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Группа безопасности для Elasticsearch
resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name        = "elasticsearch-security-group"
  network_id  = yandex_vpc_network.main.id
  description = "Security group for Elasticsearch"

  ingress {
    protocol       = "TCP"
    description    = "SSH from bastion subnet"
    port           = 22
    v4_cidr_blocks = ["10.130.10.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Elasticsearch REST API from Kibana subnet"
    port           = 9200
    v4_cidr_blocks = ["10.130.3.0/24"]  # Подсеть Kibana
  }

  ingress {
    protocol       = "TCP"
    description    = "Elasticsearch cluster communication"
    port           = 9300
    v4_cidr_blocks = ["10.130.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    description    = "from Zabbix-server"
    port           = 10050
    v4_cidr_blocks = ["10.130.2.0/24"]
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
