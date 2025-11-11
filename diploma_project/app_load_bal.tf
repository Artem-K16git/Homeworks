resource "yandex_alb_target_group" "web_servers" {
  name = "web-servers-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.web_subnets[0].id
    ip_address = yandex_compute_instance.vm[0].network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.web_subnets[1].id
    ip_address = yandex_compute_instance.vm[1].network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "web_backend" {
  name = "web-backend-group"

  http_backend {
    name             = "web-http-backend"
    weight           = 1  # Вес одинаковый для round-robin
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_servers.id]
    
    # Настройки round-robin балансировки
    load_balancing_config {
      panic_threshold = 50
      locality_aware_routing_percent = 0  # Отключаем locality-aware для чистого round-robin
      strict_locality = false
    }

    # Настройки health check
    healthcheck {
      timeout          = "10s"
      interval         = "2s"
      healthcheck_port = 80
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "web_router" {
  name = "web-router"
}

resource "yandex_alb_virtual_host" "web_virtual_host" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web_router.id
  
  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend.id
        timeout          = "60s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web_balancer" {
  name        = "web-balancer"
  network_id  = yandex_vpc_network.main.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.web_subnets[0].id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.web_subnets[1].id
    }
  }

  listener {
    name = "web-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
}
