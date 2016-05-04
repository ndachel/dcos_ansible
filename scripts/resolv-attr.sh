chattr -i /etc/resolv.conf
systemctl restart dcos-gen-resolvconf.service
