#!/bin/bash
sudo apt-get update -y
sudo apt install -y nginx
sudo apt-get install -y nodejs npm
sudo ufw allow 'Nginx Full'
sudo apt-get install git -y

# Remove the default Nginx configuration
sudo rm /etc/nginx/sites-enabled/default

# Create a new Nginx configuration file
cat << 'EOF' | sudo tee /etc/nginx/sites-available/nodejs-app
server {
    listen 80;
    server_name your_domain_or_ip;

    location / {
        proxy_pass http://localhost:4500;  # Adjust the port if your Node.js app runs on a different port
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

# Enable the new Nginx configuration
sudo ln -s /etc/nginx/sites-available/nodejs-app /etc/nginx/sites-enabled/

# Restart Nginx to apply the new configuration
sudo systemctl restart nginx

# Install PM2 globally
sudo npm install -g pm2