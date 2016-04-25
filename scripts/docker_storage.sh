if [ -d /opt/mount1/docker ]; then 
  echo "Docker has already been moved"
else
  systemctl stop docker
  mv /var/lib/docker /opt/mount1/docker
  ln -s /opt/mount1/docker /var/lib/docker
  systemctl start docker
fi
