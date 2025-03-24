sudo chcon -t samba_share_t /dev/app_share
sudo setsebool -P samba_export_all_ro=1 samba_export_all_rw=1
