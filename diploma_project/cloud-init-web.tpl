#cloud-config
users:
  - name: test-net
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${ssh_public_key}

package_update: true
package_upgrade: false

packages:
  - curl
  - wget
  - python3
  - python3-pip

runcmd:
  - |
    echo "=== Basic web server setup ==="
    # Create web directory for future use
    mkdir -p /var/www/html/
    
    # Create basic info page
    cat > /var/www/html/info.html << 'EOF'
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Server Info</title>
    </head>
    <body>
        <h1>This is $(hostname)</h1>
        <p>IP Address: $(hostname -I | awk '{print $1}')</p>
        <p>Distribution: Debian 12</p>
        <p>Role: Web Server (nginx will be installed by Ansible)</p>
        <p>Deployed: $(date)</p>
    </body>
    </html>
    EOF
    
    chmod 644 /var/www/html/info.html
    echo "=== Basic setup completed ==="

final_message: "Debian 12 web server base configuration completed"
