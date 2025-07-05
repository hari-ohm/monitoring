# Creating a user for node-exporter
sudo useradd --no-create-home node_exporter
echo "Created node_exporter user"
 
# Getting the architecture of machine
Architecture=$(uname -m)
 
if [[ "$Architecture" == "x86_64" ]]; then
    echo "Architecture: AMD64 (x86_64)"
# Downloading the node-exporter tar file for amd machine
    sudo curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
 
# Untarring the downloaded file and copying it to /usr/local/bin
    sudo tar -xvf node_exporter-1.9.1.linux-amd64.tar.gz
    sudo cp node_exporter-1.9.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
    echo "Copied node_exporter to /usr/local/bin"
 
# Removing the downloaded file and extracted file
    sudo rm -rf node_exporter-1.9.1.linux-amd64.tar.gz node_exporter-1.9.1.linux-amd64
 
elif [[ "$Architecture" == "aarch64" ]]; then
    echo "Architecture: ARM64 (aarch64)"
 
# Downloading the node-exporter tar file for arm machine
    sudo curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-arm64.tar.gz
 
# Untarring the downloaded file and copying it to /usr/local/bin
    sudo tar -xvf node_exporter-1.9.1.linux-arm64.tar.gz
    sudo cp node_exporter-1.9.1.linux-arm64/node_exporter /usr/local/bin/node_exporter
    echo "Copied node_exporter to /usr/local/bin"
 
# Removing the downloaded file and extracted file
    sudo rm -rf node_exporter-1.9.1.linux-arm64.tar.gz node_exporter-1.9.1.linux-arm64
else
    echo "Unknown architecture: $ARCHITECTURE"
    exit 1
fi
 
# Removing if any node-exporter.service file already exists
sudo rm -rf /etc/systemd/system/node-exporter.service
 
# Creating node-exporter.service file
sudo tee /etc/systemd/system/node-exporter.service > /dev/null <<EOF
[Unit]
Description=Prometheus Node Exporter Service
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network.target
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9400
 
[Install]
WantedBy=multi-user.target
EOF
 
# Running the node-exporter service
sudo systemctl daemon-reload
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
sudo systemctl status node-exporter
 
 
# If firewalld is enabled and running, add a rule for port 9400
# sudo firewall-cmd --permanent --zone=public --add-port=9400/tcp
# sudo firewall-cmd --reload