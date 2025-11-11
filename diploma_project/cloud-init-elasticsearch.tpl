#cloud-config
users:
  - name: ${vm_username}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${ssh_public_key}

package_update: true
package_upgrade: true

packages:
  - apt-transport-https
  - wget
  - curl
  - openjdk-11-jdk

write_files:
  - path: /etc/systemd/system/elasticsearch.service.d/override.conf
    content: |
      [Service]
      LimitMEMLOCK=infinity
    owner: root:root
    permissions: '0644'

runcmd:
  # Настраиваем системные лимиты для Elasticsearch
  - echo "vm.max_map_count=262144" >> /etc/sysctl.conf
  - sysctl -w vm.max_map_count=262144
  
  # Настраиваем лимиты для пользователя elasticsearch
  - echo "elasticsearch - nofile 65536" >> /etc/security/limits.conf
  - echo "elasticsearch - memlock unlimited" >> /etc/security/limits.conf
  
  # Создаем директорию для будущих логов
  - mkdir -p /var/log/elasticsearch
  - chown ${vm_username}:${vm_username} /var/log/elasticsearch

final_message: "Elasticsearch base setup completed successfully on ${hostname}. Run Ansible for full configuration."
