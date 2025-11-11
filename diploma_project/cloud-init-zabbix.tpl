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
  - curl
  - wget
  - python3
  - python3-pip

runcmd:
  - |
    # Wait for network to be fully up
    while ! ping -c1 8.8.8.8 &>/dev/null; do
      echo "Waiting for network..."
      sleep 2
    done
  
  - |
    # Install Ansible for potential post-configuration
    pip3 install ansible
  
  - |
    # Ensure system is ready for Zabbix installation
    systemctl enable apache2
    systemctl start apache2
  
  - |
    # Create directory for future Ansible operations
    mkdir -p /opt/ansible
  
  - |
    # Set proper permissions for Zabbix directories
    chown -R www-data:www-data /usr/share/zabbix/
    chmod -R 755 /usr/share/zabbix/

final_message: "Zabbix server setup completed. Run Ansible playbook for full configuration."
