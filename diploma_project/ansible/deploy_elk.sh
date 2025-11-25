#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/elk-setup"
ansible-playbook -i ../inventory/hosts.ini site.yml "$@"
