# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use Ubuntu 22.04 LTS (lightweight, LTS)
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_version = "20240823.0.1"

  # VM name
  config.vm.define "terminologue-vm"
  config.vm.hostname = "terminologue"

  # Network: port forwarding
  config.vm.network "forwarded_port", guest: 3000, host: 3000, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"

  # VM resources (lightweight)
  config.vm.provider "virtualbox" do |vb|
    vb.name = "Terminologue-VM"
    vb.memory = "1024"
    vb.cpus = 1
    vb.gui = false
  end

  # Sync folder: share the terminologue folder into VM
  config.vm.synced_folder ".", "/home/vagrant/terminologue"

  # Provisioning script
  config.vm.provision "shell", inline: <<-SHELL
    set -e
    
    echo "========================================"
    echo "  Setting up Terminologue VM"
    echo "========================================"
    
    # Update system
    apt-get update -qq
    
    # Install dependencies
    apt-get install -y -qq curl git unzip build-essential
    
    # Install Node.js 22 (LTS)
    echo "[1/5] Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null 2>&1
    apt-get install -y -qq nodejs
    node --version
    npm --version
    
    # Setup data directory
    echo "[2/5] Setting up data..."
    mkdir -p /data/termbases /data/uploads /data/downloads /data/lang
    
    # Copy template databases if they don't exist
    if [ ! -f /data/terminologue.sqlite ]; then
      cp /home/vagrant/terminologue/data/terminologue.template.sqlite /data/terminologue.sqlite
    fi
    if [ ! -f /data/lang.sqlite ]; then
      cp /home/vagrant/terminologue/data/lang.template.sqlite /data/lang.sqlite
    fi
    if [ ! -f /data/siteconfig.json ]; then
      cp /home/vagrant/terminologue/data/siteconfig.json /data/siteconfig.json
    fi
    
    # Fix siteconfig for VM environment
    sed -i 's|"baseUrl": ".*"|"baseUrl": "http://localhost:3000/"|' /data/siteconfig.json
    sed -i 's|"port": .*|"port": 3000,|' /data/siteconfig.json
    sed -i 's|"dataDir": ".*"|"dataDir": "/data/",|' /data/siteconfig.json
    sed -i 's|"sharedDir": ".*"|"sharedDir": "/home/vagrant/terminologue/shared/",|' /data/siteconfig.json
    
    # Install Terminologue dependencies
    echo "[3/5] Installing Terminologue dependencies..."
    cd /home/vagrant/terminologue/website
    npm install --silent
    
    # Install website server dependencies
    echo "[4/5] Installing website dependencies..."
    cd /home/vagrant/terminologue/public
    npm install --silent 2>/dev/null || true
    
    # Create systemd service for Terminologue
    echo "[5/5] Creating services..."
    cat > /etc/systemd/system/terminologue.service << 'EOF'
[Unit]
Description=Terminologue TMS
After=network.target

[Service]
Type=simple
User=vagrant
WorkingDirectory=/home/vagrant/terminologue/website
Environment=NODE_ENV=production
Environment=PORT=3000
ExecStart=/usr/bin/node terminologue.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    cat > /etc/systemd/system/terminologue-web.service << 'EOF'
[Unit]
Description=Terminologue Personal Website
After=network.target

[Service]
Type=simple
User=vagrant
WorkingDirectory=/home/vagrant/terminologue/public
Environment=NODE_ENV=production
Environment=PORT=8080
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    # Enable and start services
    systemctl daemon-reload
    systemctl enable terminologue.service
    systemctl enable terminologue-web.service
    systemctl start terminologue.service
    systemctl start terminologue-web.service
    
    echo ""
    echo "========================================"
    echo "  Setup Complete!"
    echo "========================================"
    echo ""
    echo "Terminologue: http://localhost:3000/"
    echo "Website:      http://localhost:8080/"
    echo ""
    echo "Admin login:"
    echo "  Email: h.darir@uca.ac.ma"
    echo "  Password: admin"
    echo ""
  SHELL
end
