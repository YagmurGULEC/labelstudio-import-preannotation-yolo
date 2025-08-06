#!/bin/bash
set -e 

dnf update -y
# dnf install -y httpd
# # Create HTML page
# echo '<h1>Hello from Apache on Amazon Linux!</h1>' | tee /var/www/html/index.html

# # Start and enable Apache
# systemctl start httpd
# systemctl enable httpd

# Install Docker
dnf install -y docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add the EC2 default user to the docker group
usermod -aG docker ec2-user
newgrp docker

# Install Python
dnf install -y git
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# Add to PATH (or source ~/.profile)
# export PATH="$HOME/.local/bin:$PATH"
