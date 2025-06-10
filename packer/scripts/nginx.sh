!#/bin/bash

sleep 30

sudo apt-get update -y
sudo apt-get install -y nginx -y
sudo systemctl enable nginx -y
sudo systemctl start nginx -y


