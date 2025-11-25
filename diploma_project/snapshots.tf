resource "yandex_compute_snapshot_schedule" "daily_backups" {
  name = "daily-vm-backups"
  
  schedule_policy {
    expression = "0 1 * * *"  # Ежедневно в 01:00
  }

  snapshot_count = 7  # 7 дней хранения

  # Все диски в одном месте
  disk_ids = [
    yandex_compute_instance.bastion.boot_disk.0.disk_id,
    yandex_compute_instance.zabbix.boot_disk.0.disk_id,
    yandex_compute_instance.elasticsearch.boot_disk.0.disk_id,
    yandex_compute_instance.kibana.boot_disk.0.disk_id,
    # + диски веб-серверов из instance group
  ]
}
