#!/bin/bash
sudo apt-get update -y
sudo apt install -y nginx
sudo apt-get install -y nodejs npm
sudo npm install pm2 -g
sudo ufw allow 'Nginx Full'