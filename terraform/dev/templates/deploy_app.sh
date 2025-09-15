#!/bin/bash
apt-get update
apt-get install -y awscli pkg-config libmysqlclient-dev
set -e
APP_DIR=""
apt-get install -y git python3-pip
git clone https://github.com/saaverdo/flask-alb-app -b orm $APP_DIR/flask-alb-app
cd $APP_DIR/flask-alb-app
pip install -r requirements.txt
# DB_HOST=$(aws ssm get-parameter --name /dev/db/MYSQL_HOST --region ${AWS_REGION} --query "Parameter.Value" --output text)

cat > /etc/systemd/system/myapp.service << EOF
[Unit]
Description=Sample web application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/flask-alb-app
Environment=MYSQL_HOST="${DB_HOST}"
Environment=FLASK_CONFIG="mysql"
Environment=MYSQL_PASS="${DB_PASSWORD}"
ExecStart=/usr/local/bin/gunicorn -b 0.0.0.0 -w 4 appy:app
Restart=always

[Install]
WantedBy=multi-user.target 
EOF

sudo systemctl daemon-reload
sudo systemctl start myapp
sudo systemctl enable myapp