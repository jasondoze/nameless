#!/bin/bash

# This script will install and run nginx in the Pi server.

if ( which nginx > /dev/null )
then 
    echo -e "\n==== Nginx is present ====\n"
else 
    echo -e "\n==== Updating apt ====\n"
    sudo apt update

    # Installing a Prebuilt Ubuntu Package from the Official NGINX Repository
    echo -e "\n==== Installing a Prebuilt Ubuntu Package ====\n"
    sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring

    # Import an official nginx signing key so apt could verify the packages authenticity. Fetch the key:
    echo -e "\n==== Importing nginx signing key ====\n"
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg > /dev/null

    # Verify that the downloaded file contains the proper key:
    echo -e "\n==== Verifying nginx signing key ====\n"
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

    # To set up the apt repository for stable nginx packages, run the following command:curl
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list

    # Set up repository pinning to prefer our packages over distribution-provided ones:
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
        | sudo tee /etc/apt/preferences.d/99nginx

    # Install NGINX Open Source
    echo -e "\n==== Installing nginx and updating apt ====\n"
    sudo apt install -y nginx

    # Start NGINX Open Source:
    echo -e "\n==== Starting nginx  ====\n"
    sudo systemctl start nginx
fi

# Copy nginx configuration file to /etc/nginx/sites-available directory
if [ -f /etc/nginx/sites-available/nginx.conf ]
then
  echo -e "\n==== nginx.conf present ====\n"
else
  echo -e "\n==== Copying nginx.conf ====\n"
  sudo cp nginx.conf /etc/nginx/sites-available/
fi

# Create a symbolic link to enable the configuration
if [ -f /etc/nginx/sites-enabled/nginx.conf ]
then
  echo -e "\n==== nginx.conf already enabled ====\n"
else
  echo -e "\n==== Enabling nginx.conf ====\n"
  sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
fi


# Restart nginx service
echo -e "\n==== Restarting nginx service ====\n"
sudo systemctl restart nginx


