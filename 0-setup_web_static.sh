#!/usr/bin/env bash
# script that sets up your web servers for the deployment of web_static

# install nginx if not previosul installed
if [ ! -x /usr/sbin/nginx ]; then
	sudo apt-get update -y -qq && \
		sudo apt-get install -y nginx
fi

# create directories using -p
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared/

# Create a fake HTML file
echo "<h2 style='text-align:center'>Welcome to tech-doc.tech</h2>" | sudo dd status=none of=/data/web_static/releases/test/index.html

# create a symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership
sudo chown -R ubuntu:ubuntu /data/

# copy
sudo cp /etc/nginx/sites-enabled/default nginx-sites-enabled_default.backup

# Update the Nginx configuration
sudo sed -i '37i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

# Restart nginx
sudo service nginx restart
echo -e "Completed without error"
