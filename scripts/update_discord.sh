#!/bin/bash

# Go to the 
cd /tmp

# Download the latest Discord source archive
wget 'https://discord.com/api/download?platform=linux' -O discord.deb

# Install .deb file using dpkg
sudo dpkg -i /tmp/discord.deb

# Remove the old Discord source archive
rm /tmp/discord.deb 
