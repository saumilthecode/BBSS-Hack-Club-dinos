#!/bin/bash

# Prompt user for subdomain + domain inputs
echo "please please please remember to set the A records in your domain registar with this server's IP"
#!/bin/bash

# Prompt user for subdomain + domain inputs
echo "Enter the domain for the 'dino' site (e.g., dino.example.com):"
read DINO_DOMAIN

echo "Enter the domain for the 'dinodisplay' site (e.g., dinodisplay.example.com):"
read DINODISPLAY_DOMAIN

# Confirm input before proceeding
echo "You entered:"
echo "- Dino domain: $DINO_DOMAIN"
echo "- Dinodisplay domain: $DINODISPLAY_DOMAIN"
read -p "Is this correct? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Aborting setup. Please run the script again and provide correct inputs."
    exit 1
fi

# Update and upgrade system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install necessary packages
echo "Installing nginx, Python, and Certbot..."
sudo apt install -y nginx python3 python3-venv python3-pip certbot python3-certbot-nginx

# Set up virtual environment (optional)
echo "Creating Python virtual environment..."
python3 -m venv ~/dino_env
source ~/dino_env/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install gunicorn flask

# Set up directories and HTML files
echo "Setting up directories and HTML files for dino and dinodisplay..."
sudo mkdir -p /var/www/dino /var/www/dinodisplay

echo "Fetching HTML files for dino and dinodisplay..."
curl -o /var/www/dino/index.html https://raw.githubusercontent.com/saumilthecode/dino-s-/main/var/www/dino/index.html
curl -o /var/www/dinodisplay/index.html https://raw.githubusercontent.com/saumilthecode/dino-s-/main/var/www/dinodisplay/index.html

# Set up Nginx configurations
echo "Setting up Nginx configurations..."
sudo bash -c "cat > /etc/nginx/sites-available/dino" <<EOF
server {
    listen 80;
    server_name $DINO_DOMAIN;

    root /var/www/dino;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

sudo bash -c "cat > /etc/nginx/sites-available/dinodisplay" <<EOF
server {
    listen 80;
    server_name $DINODISPLAY_DOMAIN;

    root /var/www/dinodisplay;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Enable Nginx configurations
echo "Enabling Nginx configurations..."
sudo ln -s /etc/nginx/sites-available/dino /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/dinodisplay /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Obtain SSL certificates
echo "Obtaining SSL certificates..."
sudo certbot --nginx -d $DINO_DOMAIN -d $DINODISPLAY_DOMAIN

# Set up Flask app
echo "Setting up Flask app..."
mkdir -p ~/dino_app/templates
curl -o ~/dino_app/app.py https://raw.githubusercontent.com/saumilthecode/dino-s-/main/dino_app/app.py
curl -o ~/dino_app/templates/admin.html https://raw.githubusercontent.com/saumilthecode/dino-s-/main/dino_app/templates/admin.html
curl -o ~/dino_app/templates/index.html https://raw.githubusercontent.com/saumilthecode/dino-s-/main/dino_app/templates/index.html

# Create a Gunicorn service for Flask app
echo "Creating Gunicorn service for Flask app..."
sudo bash -c "cat > /etc/systemd/system/dino_app.service" <<EOF
[Unit]
Description=Gunicorn instance to serve dino_app
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=/root/dino_app
Environment="PATH=/root/dino_env/bin"
ExecStart=/root/dino_env/bin/gunicorn -w 4 -b 0.0.0.0:5000 app:app

[Install]
WantedBy=multi-user.target
EOF

# Start and enable Gunicorn service
echo "Starting and enabling Gunicorn service..."
sudo systemctl start dino_app
sudo systemctl enable dino_app

# Final message
echo "Setup complete! Dino and Dinodisplay should be live:"
echo "- $DINO_DOMAIN"
echo "- $DINODISPLAY_DOMAIN"
echo "Admin panel available at [your server's IP]:5000"
