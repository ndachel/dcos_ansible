#!/bin/bash

if [ -f /etc/topbeat/topbeat.yml ]
then
  echo Nothing to do
else
  curl -L -O https://download.elastic.co/beats/topbeat/topbeat-1.2.3-x86_64.rpm
  rpm -vi topbeat-1.2.3-x86_64.rpm
fi
