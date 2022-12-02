#!/bin/bash

echo "Instalando Java......."
sudo yum update
sudo yum install java -y

echo "Verifica se o software foi instalado......."
java –version
sudo yum install java-devel -y

echo "Especifica a versao do OpenJDK......."
sudo yum install java-17-openjdk
java –version

echo "Especifica a versao do Oracle Java......."
sudo yum install wget
cd ~
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm"
sudo yum localinstall jdk-17_linux-x64_bin.rpm

echo "Java Instalado......."

echo "Instalando Zeppelin......."
wget http://www-us.apache.org/dist/zeppelin/zeppelin-0.7.3/zeppelin-0.7.3-bin-all.tgz
sudo tar xf zeppelin-*-bin-all.tgz -C /opt
sudo mv /opt/zeppelin-*-bin-all /opt/zeppelin

echo "Configurando Systemd Service......."
sudo adduser -d /opt/zeppelin -s /sbin/nologin zeppelin
sudo chown -R zeppelin:zeppelin /opt/zeppelin
sudo nano /etc/systemd/system/zeppelin.service

echo "Configurando Reverse Proxy......."
sudo yum -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo yum -y install certbot
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --reload

echo "Gerando Certificados SSL......."
sudo certbot certonly --webroot -w /usr/share/nginx/html -d zeppelin.example.com
sudo crontab -e
30 5 * * * /usr/bin/certbot renew --quiet
sudo nano /etc/nginx/conf.d/zeppelin.example.com.conf

echo "Desabilitando Acessos Anonimos......."
cd /opt/zeppelin
sudo cp conf/zeppelin-site.xml.template conf/zeppelin-site.xml
sudo nano conf/zeppelin-site.xml

echo "Abilitando Shiro Authentication......."
sudo cp conf/shiro.ini.template conf/shiro.ini
sudo nano conf/shiro.ini

echo "Reiniciando Zeppelin ......."
sudo systemctl restart zeppelin
