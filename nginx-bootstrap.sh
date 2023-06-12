#!/bin/bash
# installing nginx and overriding the default homepage.
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>Version 1.3.1 accessed from server $(hostname -f)</h1>" > /usr/share/nginx/html/index.html