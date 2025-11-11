#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/zabbix-setup"
ansible-playbook -i ../inventory/hosts.ini site.yml --extra-vars "@vars.yml" "$@"
