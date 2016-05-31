#!/bin/bash

count=`sudo docker ps -a | wc -l`;
echo Total containers: $count

count=`sudo docker ps -a -f="status=running" | wc -l`;
echo Running containers: $count

count=`sudo docker ps -aq -f="status=exited" | wc -l`;
echo Exited containers: $count
echo 

if [ $count -ne 0 ]
then
 echo Cleaning exited containers
 sudo docker rm $(sudo docker ps -aq -f="status=exited") 
 echo 
else
 echo Nothing to do
 echo
fi

count=`sudo docker ps -aq -f="status=created" | wc -l`;
echo Created containers: $count
echo 

if [ $count -ne 0 ]
then
 echo Cleaning created containers
 sudo docker rm $(sudo docker ps -aq -f="status=created") 
 echo 
else
 echo Nothing to do
 echo
fi

count=`sudo docker images -q -f="dangling=true" | wc -l`;
echo Dangling Images: $count
echo 

if [ $count -ne 0 ]
then
 echo Cleaning Dangling Images
 sudo docker rmi $(sudo docker images -q -f="dangling=true") 
 echo 
else
 echo Nothing to do
 echo
fi

# Get all the images currently in use
USED_IMAGES=($( \
    sudo docker ps -a --format '{{.Image}}' | \
    sort -u | \
    uniq | \
    awk -F ':' '$2{print $1":"$2}!$2{print $1":latest"}' \
))

# Get all the images currently available
ALL_IMAGES=($( \
    sudo docker images --format '{{.Repository}}:{{.Tag}}' | \
    sort -u \
))

# Remove the unused images
for i in "${ALL_IMAGES[@]}"; do
    UNUSED=true
    for j in "${USED_IMAGES[@]}"; do
        if [[ "$i" == "$j" ]]; then
            UNUSED=false
        fi
    done
    if [[ "$UNUSED" == true ]]; then
        sudo docker rmi "$i"
    fi
done
