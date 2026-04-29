#!/bin/bash
# EC2 One-Time Setup Script
set -e

REPO_URL="https://github.com/altaf-nextgen2ai/democicd-pipeline.git"
PROJECT_DIR="/home/ec2-user/democicd-pipeline"

echo "====> [1/5] Cloning repo..."
git clone $REPO_URL $PROJECT_DIR
cd $PROJECT_DIR

echo "====> [2/5] Virtual environment setup..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "====> [3/5] Django setup..."
cp .env.example .env
python manage.py migrate --no-input
python manage.py collectstatic --no-input

echo "====> [4/5] Gunicorn systemd service install..."
sudo cp systemd/gunicorn.service /etc/systemd/system/gunicorn.service
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn

echo "====> [5/5] Sudoers entry (password-less gunicorn restart)..."
echo "ec2-user ALL=(ALL) NOPASSWD: /bin/systemctl restart gunicorn" | sudo tee /etc/sudoers.d/gunicorn

echo ""
echo "✅ Setup complete! Server running on port 8000"
echo "   Test: curl http://16.171.1.164:8000/api/health/"
