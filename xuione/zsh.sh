#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install Zsh
echo "Installing Zsh..."
sudo apt-get install zsh -y

# Verify Zsh installation
if ! command -v zsh &> /dev/null
then
    echo "Zsh installation failed. Exiting script."
    exit 1
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
# Check if curl or wget is installed
if command -v curl &> /dev/null; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif command -v wget &> /dev/null; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Neither curl nor wget is installed. Please install one and rerun the script."
    exit 1
fi

# Change the default shell to Zsh
echo "Changing the default shell to Zsh..."
chsh -s $(which zsh)

echo "Installation complete! Please log out and log back in for changes to take effect."

