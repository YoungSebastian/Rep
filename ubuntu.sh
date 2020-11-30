#!/bin/bash
# Simple shell script to install all you need to start using ubuntu for development

POSTGRES_ROOT_PASSWORD=Kutas123

# Add docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
var=apt-cache madison docker-ce | sort -rV | head -n 1 | awk 'BEGIN{FS="|";}{print $2}' | tr -d ' '

# Add repositories of databases (MySQL, PostgreSQL)
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update/Upgrade system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install all core/usefull packages
xargs -a packages.txt sudo apt-get -y install

# Install Docker / Docker-compose
sudo apt-get install docker-ce="$var" docker-ce-cli="$var" containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Update pip
pip3 install --upgrade pip

# Add code folder
mkdir ~/Code

# Config git
git config --global user.email "sebastianozimkowski@outlook.com"
git config --global user.name "Sebastian Ozimkowski"

# Install Visual Studio Code extensions
code --install-extension ritwickdey.liveserver
code --install-extension zhuangtongfa.material-theme
code --install-extension esbenp.prettier-vscode
code --install-extension ms-python.python
code --install-extension 2gua.rainbow-brackets
code --install-extension wscats.eno
code --install-extension scode-icons-team.vscode-icons

# Install nvidia drivers
sudo ubuntu-drivers autoinstall

# Configure databases 
sudo -u postgres psql -U postgres -d postgres -c "ALTER USER postgres WITH PASSWOR '$POSTGRES_ROOT_PASSWORD';"
sudo -u postgres psql -U postgres -d postgres -c "CREATE USER sebcio03 WITH PASSWORD '$POSTGRES_ROOT_PASSWORD';"
sudo -u postgres psql -U postgres -d postgres -c "CREATE DATABASE base;"
sudo -u postgres psql -U postgres -d postgres -c "GRANT ALL PRIVILEGES ON DATABASE base TO sebcio03;"

export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password rootpw"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password rootpw"
sudo apt-get install -y 
mysql_secure_installation