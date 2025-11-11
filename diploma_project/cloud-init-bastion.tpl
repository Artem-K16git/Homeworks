#cloud-config
users:
  - name: ${vm_username}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ${ssh_public_key}

package_update: true

packages:
  - iptables-persistent

runcmd:
  - |
    echo "=== Configuring NAT on Debian 12 ==="
    # Enable IP forwarding
    echo 1 > /proc/sys/net/ipv4/ip_forward
    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

    # Configure NAT
    iptables -t nat -A POSTROUTING -s 10.130.0.0/16 -o eth0 -j MASQUERADE

    # Save rules
    iptables-save > /etc/iptables/rules.v4

    echo "=== NAT configuration completed ==="

final_message: "Debian 12 Bastion configured with NAT"
