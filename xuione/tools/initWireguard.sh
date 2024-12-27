#!/bin/bash

# Define variables
SCRIPT_PATH="/usr/local/bin/setup_wireguard.sh"
SERVICE_PATH="/etc/systemd/system/wg.service"
LOCAL_IP="192.168.0.0/16"

# Create the WireGuard setup script
echo "Creating WireGuard setup script at $SCRIPT_PATH..."
sudo bash -c "cat > $SCRIPT_PATH" <<EOL
#!/bin/bash

# Get the default gateway
GATEWAY=\$(ip route | grep default | awk '{print \$3}')

# Add a route for the local network to ensure SSH traffic bypasses the VPN
ip route add $LOCAL_IP via \$GATEWAY

# Bring up the WireGuard interface
wg-quick up wg0
EOL

# Make the script executable
echo "Making the script executable..."
sudo chmod +x $SCRIPT_PATH

# Create a systemd service file
echo "Creating systemd service at $SERVICE_PATH..."
sudo bash -c "cat > $SERVICE_PATH" <<EOL
[Unit]
Description=Setup WireGuard and network routes
After=network.target

[Service]
ExecStart=$SCRIPT_PATH
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize the new service
echo "Reloading systemd manager configuration..."
sudo systemctl daemon-reload

# Enable the service to run at boot
echo "Enabling the wg service to start at boot..."
sudo systemctl enable wg.service

# Start the service immediately
echo "Starting the wg service..."
sudo systemctl start wg.service

echo "Setup complete. The WireGuard configuration will be applied at startup."
