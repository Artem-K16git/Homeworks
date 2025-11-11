#!/bin/bash

# Интерактивный запрос имени пользователя
echo "=== Zabbix Server Cloud-Init Status Check ==="
read -p "Enter SSH username [admin]: " VM_USERNAME

# Получаем настройки из hosts.ini
BASTION_IP=$(grep -A1 "\[bastion\]" ansible/inventory/hosts.ini | tail -1 | awk '{print $1}')
ZABBIX_IP=$(grep -A1 "\[zabbix_server\]" ansible/inventory/hosts.ini | tail -1 | awk '{print $1}')

echo ""
echo "Bastion: $BASTION_IP"
echo "Zabbix Server: $ZABBIX_IP"
echo ""

# Проверяем статус cloud-init
ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -J ${VM_USERNAME}@${BASTION_IP} ${VM_USERNAME}@${ZABBIX_IP} \
    "echo 'Cloud-Init Status:'; sudo cloud-init status 2>/dev/null || echo 'Not available'; echo ''; echo 'Last Logs:'; sudo tail -5 /var/log/cloud-init-output.log 2>/dev/null || echo 'Logs not available'"
