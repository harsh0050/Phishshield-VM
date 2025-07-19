echo "log: updating apt-get..."
sudo apt-get update -y

echo "log: installing driver and node..."
sudo apt-get install chromium-chromedriver xdg-utils nodejs npm -y

#mongodb
echo "log: installing mongodb..."
sudo apt-get install gnupg curl -y
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
echo "log: updating apt-get for mongodb installation..."
sudo apt-get update -y
echo "log: installing mongodb now..."
sudo apt-get install -y mongodb-org -y
sudo systemctl start mongod
sudo systemctl enable mongod

#configure mongodb
sudo mongosh 127.0.0.1:27017/admin --eval "db.createUser({user: 'root', pwd: 'admin123', roles: [{role: 'userAdminAnyDatabase', db: 'admin'}]});"

#running app
echo "log: Setting up the app..."
git clone https://github.com/harsh0050/PhishShield.git
sudo chown -R vagrant:vagrant /home/vagrant/PhishShield/react-app
cd PhishShield
cp /vagrant/env-vars python-app/.env

cd python-app
sudo apt-get install python3-venv -y
sudo python3 -m venv myenv
source myenv/bin/activate
pip install -r requirements.txt
python3 init_database.py
# nohup python3 main.py &> python-logs.txt &

cd ../react-app
npm install
# nohup npm run dev -- --host 0.0.0.0 &> react-logs.txt &

#setting up services
echo "log: Setting up startup services..."
cd /home/vagrant/PhishShield
cp /vagrant/launch-pyserver.sh .
chmod +x launch-pyserver.sh
sudo cp /vagrant/*.service /etc/systemd/system/
sudo systemctl start pyserver
sudo systemctl start frontend
sudo systemctl enable pyserver
sudo systemctl enable frontend