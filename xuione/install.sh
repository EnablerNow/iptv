#!/bin/bash

# Step 1: Update package lists
echo "Updating package lists..."
sudo apt-get update

# Step 2: Upgrade installed packages
echo "Upgrading installed packages..."
sudo apt-get upgrade -y

# Step 3: Download XUI package
echo "Downloading XUI package..."
wget "https://update.xui.one/XUI_1.5.12.zip" -O /tmp/XUI_1.5.12.zip

# Step 4: Change directory to /tmp
echo "Changing directory to /tmp..."
cd /tmp

# Step 5: Install zip and unzip, then unzip the XUI package
echo "Installing zip and unzip, then unzipping XUI package..."
sudo apt install zip unzip -y
unzip XUI_1.5.12.zip

# Step 6: Run install script in /tmp
echo "Running install script..."
./install

# Step 7: Download xui_crack package
echo "Downloading xui_crack package..."
wget "http://tvstarlife.art/xui_crack.tar.gz" -O /tmp/xui_crack.tar.gz

# Step 8: Change directory to /tmp (again)
echo "Ensuring directory is /tmp..."
cd /tmp

# Step 9: Extract xui_crack package
echo "Extracting xui_crack package..."
tar -xf xui_crack.tar.gz

# Step 10: Execute the install script from xui_crack
echo "Executing crack install script..."
sh /tmp/install.sh

# Final step: Notify the user about panel access
echo "Installation complete. Access your panel at: http://<SERVER_IP_ADDRESS>/xxxx"
echo "Initiate configuration as required."
