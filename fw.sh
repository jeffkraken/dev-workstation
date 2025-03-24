#!/bin/bash

#requires root priviliges
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root. Exiting."
  exit 1
fi

echo "Running as root..."
echo "Starting firewall configuration..."

# Ensure firewalld is running
echo "Enabling and starting firewalld..."
sudo systemctl enable --now firewalld

#add services
firewall-cmd --permanent --add-service=samba
firewall-cmd --permanent --add-service=mysql
firewall-cmd --permanent --add-port=9090/tcp

#reload
firewall-cmd --reload

echo "Firewall configuration complete!"
