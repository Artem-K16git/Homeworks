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

write_files:
  - path: /opt/wait-for-elasticsearch.sh
    content: |
      #!/bin/bash
      echo "Waiting for Elasticsearch to be ready..."
      until curl -s http://${elasticsearch_ip}:9200 > /dev/null; do
          echo "Elasticsearch not ready yet. Retrying in 10 seconds..."
          sleep 10
      done
      echo "Elasticsearch is ready!"
    owner: root:root
    permissions: '0755'

runcmd:
  # Создаем директорию для будущих логов Kibana
  - mkdir -p /var/log/kibana
  - chown ${vm_username}:${vm_username} /var/log/kibana

final_message: "Kibana base setup completed successfully on ${hostname}. Run Ansible for full configuration. Elasticsearch endpoint: ${elasticsearch_ip}:9200"
