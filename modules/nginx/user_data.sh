#!/bin/bash
set -e

sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

sudo mkdir -p /etc/nginx/conf.d
sudo mkdir -p /usr/share/nginx/html
sudo chown -R 101:101 /etc/nginx/conf.d /usr/share/nginx/html

sudo tee /etc/nginx/conf.d/default.conf > /dev/null <<EOF
server {
    listen 80 default_server;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =200;
    }
}
EOF

sudo tee /usr/share/nginx/html/index.html > /dev/null <<EOF
<h1>Veer Meow</h1>
EOF

sudo docker run --name my-nginx -p 80:80 -d \
    -v /etc/nginx/conf.d:/etc/nginx/conf.d:ro \
    -v /usr/share/nginx/html:/usr/share/nginx/html:ro \
    nginx:latest
