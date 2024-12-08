#!/bin/bash

# Update package list and install nginx
sudo apt update
sudo apt install -y nginx

# Enable and start nginx service
sudo systemctl enable nginx
sudo systemctl start nginx

# Create directories for the HLS stream
sudo mkdir -p /var/www/hls/live
sudo chown -R www-data:www-data /var/www/hls

# Set up the Nginx configuration to serve HLS
HLS_CONF="/etc/nginx/sites-available/hls.conf"
sudo bash -c "cat > $HLS_CONF" << 'EOF'
server {
    listen 80;
    server_name _;  # Accepts requests from any hostname

    location /hls/ {
        types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
        }
        alias /var/www/hls/;
        add_header Cache-Control no-cache;
    }
}
EOF

# Enable the new configuration
sudo ln -s /etc/nginx/sites-available/hls.conf /etc/nginx/sites-enabled/

# Remove default server block if it exists
sudo rm /etc/nginx/sites-enabled/default

# Test Nginx configuration and reload
sudo nginx -t && sudo systemctl reload nginx

echo "Nginx is configured to serve HLS streams!"
