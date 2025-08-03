#!/bin/bash
set -e 

dnf update -y
dnf install -y httpd
# Create HTML page
echo '<h1>Hello from Apache on Amazon Linux!</h1>' | tee /var/www/html/index.html

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Install Docker
dnf install -y docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add the EC2 default user to the docker group
usermod -aG docker ec2-user
newgrp docker

# Install Python
dnf install -y python3 curl git
# Download and install uv
curl -Ls https://astral.sh/uv/install.sh | bash

# Add to PATH (or source ~/.profile)
export PATH="$HOME/.local/bin:$PATH"
