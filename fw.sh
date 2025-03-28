#!/bin/bash

#requires root priviliges
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  echo "For example, run [sudo ./fw.sh] but without the brackets."
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

echo "!!!secret!!!" > /root/.smb_root_pass
chmod 600 /root/.smb_root_pass


echo "Firewall configuration complete!"
