#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Variables
FOLDER_PATH="/opt/app_share"
SHARE_NAME="AppShare"

# Step 1: Install Samba (if not already installed)
echo "[*] Installing Samba packages..."
dnf install samba samba-client samba-common -y

# Step 2: Create the folder
echo "[*] Creating application folder..."
mkdir -p "$FOLDER_PATH"

# Step 3: Set permissions (root-only access)
echo "[*] Setting ownership and permissions..."
chown root:root "$FOLDER_PATH"
chmod 700 "$FOLDER_PATH"

# Step 4: Set SELinux context
echo "[*] Applying SELinux context..."
chcon -t samba_share_t "$FOLDER_PATH"
setsebool -P samba_export_all_ro=1 samba_export_all_rw=1

# Step 5: Backup Samba config
echo "[*] Backing up smb.conf..."
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Step 6: Add SMB share
echo "[*] Configuring Samba share..."
bash -c "cat >> /etc/samba/smb.conf" <<EOF

[$SHARE_NAME]
   path = $FOLDER_PATH
   browseable = yes
   read only = no
   valid users = root
   force user = root
EOF

# Step 7: Set Samba password for root
echo "[*] Setting Samba password for root..."
SMB_PASS=$(< /root/.smb_root_pass)
(echo "$SMB_PASS"; echo "$SMB_PASS") | smbpasswd -s -a root

# Step 8: Enable firewall access
echo "[*] Configuring firewall..."
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload

# Step 9: Enable and start Samba services
echo "[*] Enabling and starting Samba services..."
systemctl enable --now smb
systemctl enable --now nmb
