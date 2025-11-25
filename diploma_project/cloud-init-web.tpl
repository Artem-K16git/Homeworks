#cloud-config
users:
  - name: ${vm_username}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${ssh_public_key}

package_update: false

runcmd:
  - |
    echo "=== Forcing apt cache update ==="
    apt update
    sleep 3
  - |
    echo "=== Installing nginx-light and Ansible dependencies ==="
    apt install -y nginx-light curl wget python3 python3-pip net-tools
  - update-alternatives --install /usr/bin/python python /usr/bin/python3 1
  - systemctl enable nginx
  - systemctl start nginx
  - echo "<html><body><h1>Web Server $(hostname)</h1><p>Will be configured by Ansible</p></body></html>" > /var/www/html/inde>  - systemctl restart nginx
  - |
    echo "=== Host information ==="
    echo "Hostname: $(hostname)"
    echo "IP: $(hostname -I)"
    echo "Ready for Ansible"

final_message: "Web server $(hostname) with nginx and Ansible dependencies is ready after $UPTIME seconds"
